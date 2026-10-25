import { DatabaseSync } from 'node:sqlite';
import { readFileSync, existsSync } from 'node:fs';
import { fileURLToPath } from 'node:url';

const destination = fileURLToPath(new URL('./shopwise-demo.sqlite', import.meta.url));
if (existsSync(destination)) {
  throw new Error('Demo database already exists. Preserve it or move it before rebuilding.');
}
const database = new DatabaseSync(destination);
try {
  database.exec(readFileSync(new URL('./schema.sql', import.meta.url), 'utf8'));
  database.exec(readFileSync(new URL('./seed.sql', import.meta.url), 'utf8'));
  if (database.prepare('PRAGMA integrity_check').get().integrity_check !== 'ok') {
    throw new Error('Database integrity check failed');
  }
  if (database.prepare('PRAGMA foreign_key_check').all().length) {
    throw new Error('Foreign key check failed');
  }
  database.prepare('SELECT COUNT(*) AS offers FROM latest_offer_comparisons').get();
  console.log('Created simulated Shopwise database:', destination);
  console.log(database.prepare('SELECT COUNT(*) AS observations FROM price_observations').get());
} finally {
  database.close();
}
