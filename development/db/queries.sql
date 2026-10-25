SELECT product_name, retailer_name, branch_name, price_cents, distance_metres,
  price_state, availability, membership_required, minimum_packs,
  observed_at, valid_until, usable_before_customer_conditions, is_simulated
FROM latest_offer_comparisons
WHERE scenario_id = 'standard' AND product_id = 'milk'
ORDER BY price_cents IS NULL, price_cents, distance_metres IS NULL, distance_metres;

SELECT retailer_name, branch_name, price_cents, distance_metres
FROM latest_offer_comparisons
WHERE scenario_id = 'nearby_vs_cheapest' AND product_id = 'milk'
  AND usable_before_customer_conditions = 1 AND minimum_packs <= 1
ORDER BY price_cents, distance_metres IS NULL, distance_metres, retailer_name;

SELECT retailer_name, branch_name, price_cents, distance_metres
FROM latest_offer_comparisons
WHERE scenario_id = 'nearby_vs_cheapest' AND product_id = 'milk'
  AND usable_before_customer_conditions = 1 AND minimum_packs <= 1
ORDER BY distance_metres IS NULL, distance_metres, price_cents, retailer_name;

SELECT retailer.display_name AS chosen_store, product.display_name AS product,
  item.quantity_amount, item.quantity_unit, observation.price_cents,
  observation.price_basis_amount, observation.observed_at
FROM shopping_list_items AS item
JOIN products AS product ON product.id = item.product_id
JOIN branches AS branch ON branch.id = item.selected_branch_id
JOIN retailers AS retailer ON retailer.id = branch.retailer_id
JOIN price_observations AS observation ON observation.id = item.selected_observation_id
WHERE item.list_id = 'demo-weekly-list'
ORDER BY retailer.display_name, product.display_name;
