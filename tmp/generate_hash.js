const bcrypt = require('bcryptjs');
const password = 'matias4315';
const saltRounds = 10;
const hash = bcrypt.hashSync(password, saltRounds);
console.log('HASH_START:' + hash + ':HASH_END');
