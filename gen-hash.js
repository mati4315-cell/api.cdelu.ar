const bcrypt = require('bcryptjs');
const fs = require('fs');
const password = '@35115415';
const hash = bcrypt.hashSync(password, 10);
fs.writeFileSync('full_hash.txt', hash, 'utf8');
console.log('Done');
