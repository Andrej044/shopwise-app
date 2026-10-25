PRAGMA foreign_keys = ON;

CREATE TABLE simulation_metadata (
  key TEXT PRIMARY KEY,
  value TEXT NOT NULL
) STRICT;

CREATE TABLE retailers (
  id TEXT PRIMARY KEY,
  display_name TEXT NOT NULL UNIQUE,
  is_simulated INTEGER NOT NULL DEFAULT 1 CHECK (is_simulated = 1)
) STRICT;

CREATE TABLE branches (
  id TEXT PRIMARY KEY,
  retailer_id TEXT NOT NULL REFERENCES retailers(id),
  display_name TEXT NOT NULL,
  locality TEXT NOT NULL DEFAULT 'Toronto simulation',
  address TEXT,
  latitude REAL,
  longitude REAL,
  navigable INTEGER NOT NULL DEFAULT 0 CHECK (navigable = 0),
  is_simulated INTEGER NOT NULL DEFAULT 1 CHECK (is_simulated = 1),
  CHECK (address IS NULL AND latitude IS NULL AND longitude IS NULL)
) STRICT;

CREATE TABLE products (
  id TEXT PRIMARY KEY,
  display_name TEXT NOT NULL,
  brand TEXT NOT NULL DEFAULT 'Shopwise Demo',
  category TEXT NOT NULL,
  variant TEXT NOT NULL,
  pack_amount INTEGER NOT NULL CHECK (pack_amount > 0),
  measure_unit TEXT NOT NULL CHECK (measure_unit IN ('g', 'mL', 'each')),
  sale_basis TEXT NOT NULL CHECK (sale_basis IN ('pack', 'weight')),
  image_path TEXT NOT NULL,
  alternative_to_product_id TEXT REFERENCES products(id),
  is_simulated INTEGER NOT NULL DEFAULT 1 CHECK (is_simulated = 1)
) STRICT;

CREATE TABLE scenarios (
  id TEXT PRIMARY KEY,
  display_name TEXT NOT NULL,
  description TEXT NOT NULL,
  as_of TEXT NOT NULL,
  currency TEXT NOT NULL DEFAULT 'CAD' CHECK (currency = 'CAD'),
  maximum_price_age_hours INTEGER NOT NULL DEFAULT 24 CHECK (maximum_price_age_hours > 0)
) STRICT;

CREATE TABLE distance_fixtures (
  scenario_id TEXT NOT NULL REFERENCES scenarios(id),
  branch_id TEXT NOT NULL REFERENCES branches(id),
  distance_metres INTEGER CHECK (distance_metres >= 0),
  basis TEXT NOT NULL DEFAULT 'synthetic_fixture' CHECK (basis = 'synthetic_fixture'),
  origin_label TEXT NOT NULL DEFAULT 'Fictional demo origin; not a real address',
  PRIMARY KEY (scenario_id, branch_id)
) STRICT;

CREATE TABLE price_observations (
  id INTEGER PRIMARY KEY,
  scenario_id TEXT NOT NULL REFERENCES scenarios(id),
  branch_id TEXT NOT NULL REFERENCES branches(id),
  product_id TEXT NOT NULL REFERENCES products(id),
  price_cents INTEGER CHECK (price_cents >= 0),
  price_basis_amount INTEGER NOT NULL CHECK (price_basis_amount > 0),
  price_state TEXT NOT NULL CHECK (price_state IN ('known', 'unknown')),
  availability TEXT NOT NULL DEFAULT 'unknown' CHECK (availability IN ('in_stock', 'out_of_stock', 'unknown')),
  membership_required INTEGER NOT NULL DEFAULT 0 CHECK (membership_required IN (0, 1)),
  minimum_packs INTEGER NOT NULL DEFAULT 1 CHECK (minimum_packs > 0),
  price_channel TEXT NOT NULL DEFAULT 'in_store' CHECK (price_channel IN ('in_store', 'warehouse', 'online')),
  observed_at TEXT NOT NULL,
  valid_until TEXT NOT NULL,
  source_type TEXT NOT NULL DEFAULT 'simulation' CHECK (source_type = 'simulation'),
  conditions TEXT NOT NULL DEFAULT '',
  is_simulated INTEGER NOT NULL DEFAULT 1 CHECK (is_simulated = 1),
  UNIQUE (scenario_id, branch_id, product_id, observed_at),
  CHECK ((price_state = 'known' AND price_cents IS NOT NULL) OR (price_state = 'unknown' AND price_cents IS NULL)),
  CHECK (valid_until > observed_at)
) STRICT;

CREATE TABLE shopping_lists (
  id TEXT PRIMARY KEY,
  scenario_id TEXT NOT NULL REFERENCES scenarios(id),
  title TEXT NOT NULL,
  is_simulated INTEGER NOT NULL DEFAULT 1 CHECK (is_simulated = 1)
) STRICT;

CREATE TABLE shopping_list_items (
  id TEXT PRIMARY KEY,
  list_id TEXT NOT NULL REFERENCES shopping_lists(id),
  product_id TEXT NOT NULL REFERENCES products(id),
  selected_branch_id TEXT NOT NULL REFERENCES branches(id),
  selected_observation_id INTEGER NOT NULL REFERENCES price_observations(id),
  quantity_amount INTEGER NOT NULL CHECK (quantity_amount > 0),
  quantity_unit TEXT NOT NULL CHECK (quantity_unit IN ('pack', 'g')),
  completed INTEGER NOT NULL DEFAULT 0 CHECK (completed IN (0, 1)),
  is_simulated INTEGER NOT NULL DEFAULT 1 CHECK (is_simulated = 1)
) STRICT;

CREATE TRIGGER validate_list_selection_insert BEFORE INSERT ON shopping_list_items
BEGIN
  SELECT CASE WHEN NOT EXISTS (
    SELECT 1 FROM price_observations AS observation
    JOIN shopping_lists AS list ON list.scenario_id = observation.scenario_id
    JOIN products AS product ON product.id = observation.product_id
    WHERE list.id = NEW.list_id
      AND observation.id = NEW.selected_observation_id
      AND observation.product_id = NEW.product_id
      AND observation.branch_id = NEW.selected_branch_id
      AND ((product.sale_basis = 'weight' AND NEW.quantity_unit = 'g') OR (product.sale_basis = 'pack' AND NEW.quantity_unit = 'pack'))
  ) THEN RAISE(ABORT, 'List selection must match product, branch, scenario and quantity unit') END;
END;

CREATE TRIGGER validate_list_selection_update BEFORE UPDATE ON shopping_list_items
BEGIN
  SELECT CASE WHEN NOT EXISTS (
    SELECT 1 FROM price_observations AS observation
    JOIN shopping_lists AS list ON list.scenario_id = observation.scenario_id
    JOIN products AS product ON product.id = observation.product_id
    WHERE list.id = NEW.list_id
      AND observation.id = NEW.selected_observation_id
      AND observation.product_id = NEW.product_id
      AND observation.branch_id = NEW.selected_branch_id
      AND ((product.sale_basis = 'weight' AND NEW.quantity_unit = 'g') OR (product.sale_basis = 'pack' AND NEW.quantity_unit = 'pack'))
  ) THEN RAISE(ABORT, 'List selection must match product, branch, scenario and quantity unit') END;
END;

CREATE INDEX observations_lookup ON price_observations(scenario_id, product_id, branch_id, observed_at DESC);

CREATE VIEW latest_offer_comparisons AS
WITH ranked AS (
  SELECT observation.*, ROW_NUMBER() OVER (
    PARTITION BY observation.scenario_id, observation.branch_id, observation.product_id ORDER BY observation.observed_at DESC, observation.id DESC
  ) AS observation_rank
  FROM price_observations AS observation
  JOIN scenarios AS scenario ON scenario.id = observation.scenario_id
  WHERE julianday(observation.observed_at) <= julianday(scenario.as_of)
)
SELECT ranked.id AS observation_id, ranked.scenario_id, ranked.product_id,
  product.display_name AS product_name, product.pack_amount, product.measure_unit, product.sale_basis,
  branch.id AS branch_id, retailer.display_name AS retailer_name, branch.display_name AS branch_name,
  ranked.price_cents, ranked.price_basis_amount, ranked.price_state, ranked.availability,
  ranked.membership_required, ranked.minimum_packs, ranked.price_channel,
  ranked.observed_at, ranked.valid_until, ranked.conditions, ranked.source_type, ranked.is_simulated,
  distance.distance_metres,
  CASE WHEN ranked.price_state = 'known'
    AND ranked.availability != 'out_of_stock'
    AND julianday(ranked.valid_until) > julianday(scenario.as_of)
    AND (julianday(scenario.as_of) - julianday(ranked.observed_at)) * 24 <= scenario.maximum_price_age_hours
    THEN 1 ELSE 0 END AS usable_before_customer_conditions
FROM ranked
JOIN scenarios AS scenario ON scenario.id = ranked.scenario_id
JOIN products AS product ON product.id = ranked.product_id
JOIN branches AS branch ON branch.id = ranked.branch_id
JOIN retailers AS retailer ON retailer.id = branch.retailer_id
LEFT JOIN distance_fixtures AS distance ON distance.scenario_id = ranked.scenario_id AND distance.branch_id = ranked.branch_id
WHERE ranked.observation_rank = 1;
