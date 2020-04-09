const port = 27017;
const host = process.env.DB_HOST;
const name = process.env.DB_NAME;

const config = {
  mongodb: {
    url: `mongodb://${host}:${port}`,
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
