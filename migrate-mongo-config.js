const port = process.env.DB_PORT;
const host = process.env.DB_HOST;
const name = process.env.DB_NAME;

const user = process.env.DB_USER;
const pass = process.env.DB_PASS;
const auth = process.env.DB_AUTH === "true" ? `${user}:${pass}@` : "";

const appName = process.env.DB_APPNAME;
const ssl = process.env.DB_SSL === "true" ? `?ssl=true&appName=@${appName}@` : "";

const trace = a => {
  console.log(a);
  return a;
};

const config = {
  mongodb: {
    url: trace(`mongodb://${auth}${host}:${port}/${ssl}`),
    databaseName: name,

    options: {
      useNewUrlParser: true, // removes a deprecation warning when connecting
      useUnifiedTopology: true, // removes a deprecating warning when connecting
    }
  },
  migrationsDir: "migrations",
  changelogCollectionName: "changelog"
};

module.exports = config;
