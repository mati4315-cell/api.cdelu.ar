
const axios = require('axios');

async function test() {
  try {
    const feedId = 1109; // Valid feedId for the 1307 news (based on the previous output)
    console.log(`Testing comments for feedId: ${feedId}...`);
    const response = await axios.get(`http://localhost:3001/api/v1/feed/${feedId}/comments`);
    console.log('Status:', response.status);
    console.log('Data (first comment):', response.data[0]);
  } catch (error) {
    if (error.response) {
      console.log('Status:', error.response.status);
      console.log('Error Data:', error.response.data);
    } else {
      console.error('Error:', error.message);
    }
  }
}

test();
