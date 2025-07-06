const path = require("path");
const fs = require("fs");
const kuzu = require("./../");
// ## the extensions will install to ~/.kuzu/extension/0.10.0/win_amd64/xxx  refer https://extension.kuzudb.com/v0.10.0/win_amd64/xxx
(async () => {
  // Create an empty on-disk database and connect to it
  let dbPath = path.join(__dirname, "./demo_test.db");
  if (fs.existsSync(dbPath)) {
    // Delete the existing database
    fs.rmSync(dbPath, { recursive: true, force: true });
  }
  const db = new kuzu.Database(dbPath);
  console.log("Version is", kuzu.VERSION);
  console.log("Storage version is", kuzu.STORAGE_VERSION);

  const conn = new kuzu.Connection(db);
  try {
    await conn.query(`
      CREATE NODE TABLE Movie (name STRING, PRIMARY KEY(name));
      CREATE NODE TABLE Person (name STRING, birthDate STRING, PRIMARY KEY(name));
      CREATE REL TABLE ActedIn (FROM Person TO Movie);
      CREATE (:Person {name: 'Al Pacino', birthDate: '1940-04-25'});
      CREATE (:Person {name: 'Robert De Nero', birthDate: '1943-08-17'});
      CREATE (:Movie {name: 'The Godfather: Part II'});
      MATCH (p:Person), (m:Movie) WHERE p.name = 'Al Pacino' AND m.name = 'The Godfather: Part II' CREATE (p)-[:ActedIn]->(m);
      MATCH (p:Person), (m:Movie) WHERE p.name = 'Robert De Nero' AND m.name = 'The Godfather: Part II' CREATE (p)-[:ActedIn]->(m);
      `);
  } catch (e) {
    console.error("Create DB failed:",e.message);
  }

  await conn.query(`load neo4j;`);
  const queryResult = await conn.query(`MATCH (p:Person)-[r:ActedIn]->(m:Movie) RETURN *;`);

  // conn.query(`EXPORT DATABASE "./util/demo_db_export" `);

  // Get all rows from the query result
  const rows = await queryResult.getAll();

  // Print the rows
  for (const row of rows) {
    console.log(row);
  }
  queryResult.close();
  conn.close();
  db.close();

  process.exit(0);

})();
