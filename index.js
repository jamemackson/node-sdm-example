const { Client } = require("pg");
const { parse } = require("pg-connection-string");
const { promisify } = require("util");

(async () => {
  const reviewappName = process.argv[2];
  if (!reviewappName) {
    console.error("must specify review app name as first argument");
    // eslint-disable-next-line no-process-exit
    process.exit();
  }

  const pgsvr = parse(process.env.DATABASE_URL);
  console.log("parsed connection", { pgsvr });
  const client = new Client({
    user: pgsvr.user,
    host: pgsvr.host,
    database: pgsvr.database,
    password: pgsvr.password,
    port: parseInt(pgsvr.port, 10),
  });

  console.log("client connecting...");
  client.connect();

  console.log(`checking if ${reviewappName} database exists...`);

  // check to see if the database exists
  const query = promisify(client.query).bind(client);
  const res = await query(`SELECT datname FROM pg_database where datname = '${reviewappName}'`);
  console.log("received response", { rows: res.rows, len: res.rows.length });

  if (res.rows.length > 0) {
    console.log(`database ${reviewappName} already exists`);
  } else {
    console.log(`database ${reviewappName} does not exist.`);
  }
  process.exit();
})();
