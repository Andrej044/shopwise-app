# Fictional grocery price preview

**SIMULATION ONLY — THESE ARE NOT REAL PRICES FROM THESE RETAILERS.**

Scenario: `standard`. Frozen demo time: 25 October 2026, 12:00 UTC. All amounts are CAD. Branches, prices and stock status are synthetic. Costco values assume the simulated membership condition; no membership number is required. Inventory is unconfirmed for all rows in this scenario.

| Generic demo product | Quoted quantity | No Frills | Metro | Costco (member) | Loblaws | Walmart |
| --- | --- | --- | --- | --- | --- | --- |
| Apples | 1000 g · weighed basis | $3.49 | $3.99 | $3.29 | $4.49 | $3.59 |
| Bananas | 1000 g · weighed basis | $1.79 | $2.19 | $1.69 | $2.29 | $1.89 |
| Bread | 675 g · one pack | $2.99 | $3.49 | $2.79 | $3.79 | $2.89 |
| Broccoli | 1 each · one pack | $2.49 | $3.29 | $2.79 | $3.49 | $2.69 |
| Carrots | 907 g · one pack | $2.29 | $2.79 | $2.49 | $2.99 | $2.19 |
| Cheddar cheese | 400 g · one pack | $5.49 | $5.99 | $5.29 | $6.49 | $5.79 |
| Chicken breast | 1000 g · weighed basis | $10.99 | $12.49 | $10.49 | $13.49 | $11.49 |
| Eggs | 12 each · one pack | $3.99 | $4.49 | $3.79 | $4.69 | $4.09 |
| Milk | 4000 mL · one pack | $4.79 | $4.99 | $4.59 | $5.29 | $4.89 |
| Oranges | 1000 g · weighed basis | $2.99 | $3.49 | $2.79 | $3.79 | $3.19 |
| Penne pasta | 500 g · one pack | $1.79 | $2.19 | $1.69 | $2.49 | $1.89 |
| Potatoes | 2270 g · one pack | $4.49 | $4.99 | $4.29 | $5.49 | $3.99 |
| White rice | 1000 g · one pack | $3.49 | $3.99 | $3.29 | $4.29 | $2.99 |
| Salmon | 1000 g · weighed basis | $22.99 | $24.99 | $21.99 | $26.99 | $23.99 |
| Strawberries | 454 g · one pack | $3.99 | $4.49 | $3.79 | $4.99 | $3.49 |
| Tomatoes | 1000 g · weighed basis | $3.49 | $4.29 | $3.29 | $4.49 | $3.79 |
| Plain yogurt | 750 g · one pack | $3.49 | $3.99 | $3.29 | $4.29 | $3.79 |

## Example list

The fixture list deliberately keeps milk at Metro, bananas at No Frills, eggs at Walmart, and bread at Loblaws. Its simulated subtotal is $14.21 for 1 milk pack, 750 g bananas, 1 egg pack and 1 loaf. Store assignments are user choices, not automatic cheapest-store substitutions.

## Read the scenarios

Eight scenarios also cover tied prices, cheaper-but-farther stores, stale/missing prices, membership and bulk packs, unavailable location, changed prices and incomplete basket coverage. See `README.md` for details and formulas. Two bulk alternatives are separate products so they cannot silently replace a normal pack.

This table is a snapshot of the saved SQLite fixture, not a retailer feed. No real branch address or directions are supplied. Existing product images remain illustrative.
