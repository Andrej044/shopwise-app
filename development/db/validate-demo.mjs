import assert from 'node:assert/strict';
import { DatabaseSync } from 'node:sqlite';
import { readFileSync, existsSync } from 'node:fs';
import { fileURLToPath } from 'node:url';

const database = new DatabaseSync(':memory:');
database.exec(readFileSync(new URL('./schema.sql', import.meta.url), 'utf8'));
database.exec(readFileSync(new URL('./seed.sql', import.meta.url), 'utf8'));

function offers(scenario, product, member = false, packs = 1, sort = 'price') {
  const order = sort === 'distance'
    ? 'distance_metres IS NULL, distance_metres, price_cents, retailer_name'
    : 'price_cents, distance_metres IS NULL, distance_metres, retailer_name';
  return database.prepare(`SELECT * FROM latest_offer_comparisons
    WHERE scenario_id = ? AND product_id = ?
      AND usable_before_customer_conditions = 1
      AND (membership_required = 0 OR ? = 1) AND minimum_packs <= ?
    ORDER BY ${order}`).all(scenario, product, Number(member), packs);
}

try {
  assert.equal(database.prepare('SELECT COUNT(*) AS total FROM retailers').get().total, 5);
  assert.equal(database.prepare('SELECT COUNT(*) AS total FROM products').get().total, 19);
  assert.equal(database.prepare('SELECT COUNT(*) AS total FROM scenarios').get().total, 8);
  assert.equal(database.prepare('SELECT COUNT(*) AS total FROM price_observations').get().total, 688);
  assert.equal(database.prepare('PRAGMA integrity_check').get().integrity_check, 'ok');
  assert.deepEqual(database.prepare('PRAGMA foreign_key_check').all(), []);
  assert.equal(offers('standard', 'milk').length, 4);
  assert.equal(offers('standard', 'milk', true).length, 5);
  assert.equal(offers('standard', 'milk')[0].retailer_name, 'No Frills');
  assert.equal(offers('standard', 'milk', true)[0].retailer_name, 'Costco');
  const tied = offers('ties', 'milk', true);
  assert.equal(tied[0].price_cents, tied[1].price_cents);
  assert.deepEqual(tied.slice(0, 2).map(row => row.retailer_name), ['Metro', 'No Frills']);
  assert.equal(offers('nearby_vs_cheapest', 'milk', true)[0].retailer_name, 'Costco');
  assert.equal(offers('nearby_vs_cheapest', 'milk', true, 1, 'distance')[0].retailer_name, 'Metro');
  assert.equal(offers('nearby_vs_cheapest', 'milk', true, 1, 'distance').at(-1).retailer_name, 'Costco');
  assert.deepEqual(offers('stale_missing', 'milk', true).map(row => row.retailer_name), ['Loblaws']);
  assert.equal(offers('bulk_membership', 'bread', false, 1).some(row => row.retailer_name === 'Metro'), false);
  assert.equal(offers('bulk_membership', 'bread', false, 2)[0].retailer_name, 'Metro');
  const singleRice = offers('bulk_membership', 'rice', true).find(row => row.retailer_name === 'Costco');
  const bulkRice = offers('bulk_membership', 'rice-bulk', true)[0];
  assert.ok(bulkRice.price_cents > singleRice.price_cents);
  assert.ok(bulkRice.price_cents / bulkRice.price_basis_amount < singleRice.price_cents / singleRice.price_basis_amount);
  assert.ok(offers('no_location', 'milk', true).every(row => row.distance_metres === null));
  assert.equal(offers('price_change', 'milk').find(row => row.retailer_name === 'Metro').price_cents, 529);
  assert.equal(offers('partial_basket', 'salmon', true).length, 0);
  assert.equal(database.prepare("SELECT selected_branch_id FROM shopping_list_items WHERE id = 'demo-item-milk'").get().selected_branch_id, 'demo-metro');
  assert.throws(() => database.exec("UPDATE shopping_list_items SET selected_branch_id='demo-walmart' WHERE id='demo-item-milk'"), /must match/);
  assert.throws(() => database.exec("UPDATE shopping_list_items SET quantity_unit='pack' WHERE id='demo-item-bananas'"), /must match/);
  assert.throws(() => database.exec('UPDATE price_observations SET price_cents = -1 WHERE id = 1'), /CHECK constraint/);
  assert.throws(() => database.exec("UPDATE branches SET address='Real street' WHERE id='demo-metro'"), /CHECK constraint/);
  assert.throws(() => database.exec("UPDATE price_observations SET source_type='live' WHERE id=1"), /CHECK constraint/);
  const selectedRows = database.prepare(`SELECT item.quantity_amount, item.quantity_unit, observation.price_cents,
    observation.price_basis_amount FROM shopping_list_items AS item
    JOIN price_observations AS observation ON observation.id = item.selected_observation_id`).all();
  const total = selectedRows.reduce((sum, row) => sum + (row.quantity_unit === 'pack'
    ? row.price_cents * row.quantity_amount
    : Math.floor((row.price_cents * row.quantity_amount * 2 + row.price_basis_amount) / (2 * row.price_basis_amount))), 0);
  assert.equal(total, 1421);
  const productRows = database.prepare('SELECT image_path FROM products').all();
  assert.ok(productRows.every(row => existsSync(fileURLToPath(new URL(row.image_path, import.meta.url)))));
  const saved = new DatabaseSync(fileURLToPath(new URL('./shopwise-demo.sqlite', import.meta.url)), { readOnly: true });
  try {
    assert.equal(saved.prepare('PRAGMA integrity_check').get().integrity_check, 'ok');
    assert.deepEqual(saved.prepare('PRAGMA foreign_key_check').all(), []);
    assert.equal(saved.prepare('SELECT COUNT(*) AS total FROM price_observations').get().total, 688);
  } finally {
    saved.close();
  }
  console.log('PASS: fixture counts, eligible price/distance ordering, ties, stale/missing/out-of-stock exclusions, membership, multi-buy, bulk outlay, no location, changed price, incomplete coverage, saved store selection, database constraints, weighted totals, image references, and saved database integrity.');
} finally {
  database.close();
}
