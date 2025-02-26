const kuzu = require("./../");

(async () => {
  // Create an empty on-disk database and connect to it
  const db = new kuzu.Database("./demo_db");
  const conn = new kuzu.Connection(db);

  await conn.query("CREATE NODE TABLE Movie (name STRING, PRIMARY KEY(name))")
  await conn.query("CREATE NODE TABLE Person (name STRING, birthDate STRING, PRIMARY KEY(name))")
  await conn.query("CREATE REL TABLE ActedIn (FROM Person TO Movie)")

  await conn.query("CREATE (:Person {name: 'Al Pacino', birthDate: '1940-04-25'})")
  await conn.query("CREATE (:Person {name: 'Robert De Nero', birthDate: '1943-08-17'})")
  await conn.query("CREATE (:Movie {name: 'The Godfather: Part II'})")
  await conn.query("MATCH (p:Person), (m:Movie) WHERE p.name = 'Al Pacino' AND m.name = 'The Godfather: Part II' CREATE (p)-[:ActedIn]->(m)")
  await conn.query("MATCH (p:Person), (m:Movie) WHERE p.name = 'Robert De Nero' AND m.name = 'The Godfather: Part II' CREATE (p)-[:ActedIn]->(m)")

  const queryResult = await conn.query("MATCH (p)-[:ActedIn]->(m) RETURN *");

  // Get all rows from the query result
  const rows = await queryResult.getAll();

  // Print the rows
  for (const row of rows) {
    console.log(row);
  }

  //删除demo_db


})();