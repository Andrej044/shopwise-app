# Shopwise simulated grocery database

**FICTIONAL DEMO DATA — NOT REAL RETAILER PRICES OR INVENTORY.** Prepared 25 October 2026. No live retailer integration or application implementation is included.

## What is ready

`shopwise-demo.sqlite` is a real local SQLite database for design/development simulations. It contains five retailer identities, five fictional branches, seventeen core products using the existing image assets, two separately identified bulk-pack alternatives, eight scenarios, 688 price observations, synthetic distances, and a sample shopping list retaining the shopper's chosen stores.

Use **one database with separate tables**, rather than separate databases for every chain. This makes it straightforward to compare the same product across stores and keeps product identity, quantities and store selections consistent. Scenarios provide different test conditions without maintaining unrelated store databases.

The retailer names are real: No Frills, Metro, Costco, Loblaws, Walmart. Every branch, price, availability value, distance and promotion in this dataset is invented. Products use a fictitious “Shopwise Demo” identity, not verified branded SKUs or GTINs. The fixture does not claim these exact packs are sold at those chains. Store branches have no coordinates or street addresses and cannot be used for navigation.

## Files

| File | Purpose |
| --- | --- |
| `shopwise-demo.sqlite` | Ready-to-open simulated database |
| `schema.sql` | Reproducible table, index, view and constraint definitions |
| `seed.sql` | Explicit synthetic prices and scenario construction |
| `queries.sql` | Readable example comparisons and chosen-store list retrieval |
| `build-demo.mjs` | Local database creation helper using Node's built-in SQLite support |
| `validate-demo.mjs` | Checks price sorting, eligibility, data integrity and selection behaviour |

The helpers prepare and verify database fixtures; they are not frontend/backend application code. Node 24 or a compatible runtime with `node:sqlite` is needed to use them. Open the SQLite file directly with a SQLite database viewer if you only want to inspect the data. Rebuilding refuses to overwrite an existing database.

## Scenarios

| ID | Demonstrates |
| --- | --- |
| `standard` | All five stores have known synthetic prices; Costco offers require simulated membership eligibility |
| `ties` | Equal lowest milk prices at Metro and No Frills; nearer Metro ranks first among the ties |
| `nearby_vs_cheapest` | Costco is cheapest for milk for an eligible demo member, Metro is nearest, and Costco is farthest |
| `stale_missing` | Expired No Frills price, unknown Metro price, out-of-stock Costco milk, overly old Walmart observation; Loblaws is the only usable milk offer |
| `bulk_membership` | Separate large rice/pasta packs at Costco and a Metro bread minimum-quantity condition |
| `no_location` | Distances are unknown; price comparison still works |
| `price_change` | Metro milk changes from a prior observation to a newer price; confirm changes before adding |
| `partial_basket` | All stores lack a known salmon price; a complete basket estimate is unavailable |

All scenario clocks are pinned to **2026-10-25T12:00:00Z** so results are reproducible. This is the scenario time, not today's actual freshness. If integrated into a later demo, show “Simulation as of 25 October 2026” and use the fixture clock for demo eligibility. Production must use the real current time and a real ingestion/freshness policy; these fixture thresholds are not retailer guarantees.

## Table relationships

Retailer → fictional branch → price observations ← product. A scenario supplies the evaluation time and the distance fixtures. A shopping list belongs to one scenario. Each list item references its product, chosen branch and the exact observation selected by the shopper.

`latest_offer_comparisons` selects the latest observation at or before the scenario clock for each product/branch. An old historical row is retained for testing but never used as an invented “regular price” savings baseline. A newer unknown or unusable observation must not be replaced with an older convenient price.

The view's `usable_before_customer_conditions` only assesses known price, availability not explicitly out of stock, expiry and the fixture age threshold. It is **not final customer eligibility**: separately enforce membership, requested quantity/minimum packs and channel. Inventory “unknown” remains usable for a labelled price estimate and is never a claim that stock is guaranteed. Price state “unknown” uses NULL, not zero.

## Panel sorting and list selection

Use the product-offer panel from the design handbook. Filter by exact product, scenario, eligible conditions and supported channel. Sort Cheapest by requested line amount, then known distance for ties; Nearest by known distance, then line amount. Missing-distance rows follow known distances. Keep ineligible and missing-price rows visible in a separate unranked section. All tied minimum eligible line amounts can receive the cheapest badge; sorting a tie does not remove the badge from the other tied offer.

For fixed packs of the same exact product, multiplication by the same requested pack count preserves the price ordering shown in the sample queries. For weighed goods and alternative pack sizes, compute required quantity and cash outlay before ranking; do not blindly sort unrelated pack prices. The second and third queries assume the user has the simulated Costco membership and requests one pack. Add `membership_required = 0` when that eligibility is absent or unknown. Minimum-quantity conditions must be applied for the actual requested count, not assumed from a badge.

When an offer is selected, retain its branch and observation ID on the list item. Do not replace that choice when sorting or discovering a lower price. The example list deliberately selects Metro for milk even though another store has a lower synthetic price. Selecting a new store requires explicit confirmation in the later application.

Foreign keys and triggers ensure each selected observation matches the item's product, branch, scenario and quantity unit. This fixture is not a full production schema: the later service must enforce observation immutability, authorization, scenario consistency when parent records change, and current eligibility inside a transactional add/update operation. Do not edit the fixture's price history as a way to mutate a user's already captured price.

## Money and quantity conventions

All money is integer **CAD cents**. `pack_amount` and `price_basis_amount` use the product's `measure_unit`: grams, millilitres, or each. Weighted produce, chicken and salmon use a synthetic price per 1000 g; list quantity is grams. Packaged products use quantity in whole packs. A 12-egg carton is one pack containing twelve each, not twelve packs.

For a packaged line: line cents = pack price cents × number of packs. For a weighed line: line cents = round-half-up(price cents × requested grams ÷ quoted basis grams). Round once per line, then sum rounded lines. Actual weighed checkout quantity can differ from the estimate. Do not use floating-point money as the authoritative stored value.

The example list has milk at Metro for 499 cents, 750 g bananas at No Frills at 179 cents/kg (134 cents after rounding), eggs at Walmart for 409 cents, and bread at Loblaws for 379 cents. Its synthetic grocery subtotal is **1421 cents ($14.21)** before any applicable taxes/deposits and travel.

The bulk rice alternative costs 999 cents for 4000 g, versus 329 cents for a 1000 g demo Costco rice pack. The bulk unit price is lower, but buying the bulk pack costs more cash for a 1 kg request. Never assign it silently as if it were the same pack. The same rule applies to pasta alternatives.

## Savings and travel limits

This database supplies prices and synthetic one-way origin-to-branch distances for panel sorting. It does **not** supply a road network, inter-store distances, return journeys, travel times, fuel/parking costs or an optimizer. Do not add origin distances together and call that an optimized trip. Multi-store optimization requires a consistent route matrix, origin/end assumptions, transport mode and travel-cost model later.

For a comparison on the same complete basket: gross grocery savings = baseline grocery subtotal − proposed grocery subtotal; net savings = (baseline groceries + baseline travel) − (proposed groceries + proposed travel). Label both baselines and separate travel. If net percentage is shown, divide net savings by the explicitly labelled baseline total including travel; suppress when that total is zero or unavailable. No reference to “regular price” is provided by these fixtures.

If any required line is unpriced, show priced-line coverage and partial subtotal, not full-basket savings. There is no realized/receipt-verified savings claim. No auth, personal information, retailer credentials, payments, orders, delivery or in-app purchasing is present.

## Future separation from real data

Keep this database isolated from production and retain a persistent demo banner. `source_type='simulation'` and simulation-only constraints help prevent accidental relabelling, but deployment configuration must also prevent loading these files into a live-price environment. A future real data system needs authorized retailer sources, real product identifiers, verified branches, ingestion jobs, source rights, price/channel evidence, freshness and inventory limitations; none is simulated into legitimacy by this fixture.
