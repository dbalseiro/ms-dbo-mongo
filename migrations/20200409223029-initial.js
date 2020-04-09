module.exports = {
  async up(db, client) {
    await db.collection('matters').insertMany([{
      "client_num": "4",
      "docket_num": "1",
      "matter_num": "3",
      "client_docket_num": "2"
    }]);
  },

  async down(db, client) {
    await db.collection('matters').deleteMany({});
  }
};
