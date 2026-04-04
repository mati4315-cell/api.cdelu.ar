
const axios = require('axios');

async function test() {
  try {
    console.log('Testing by-original-id endpoint...');
    // Assuming type 1 (news) and originalId 1307 (from user's example)
    // We might need a real ID, but let's see if the endpoint exists and responds.
    const response = await axios.get('http://localhost:3001/api/v1/feed/by-original-id/1/1307');
    console.log('Response state:', response.status);
    console.log('Data:', response.data);
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
