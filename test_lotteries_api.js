const axios = require('axios');

async function testLotteriesApi() {
  const url = 'https://api.cdelu.ar/api/v1/lotteries?status=active';
  
  try {
    console.log(`📡 Llamando a: ${url}...`);
    const response = await axios.get(url);
    console.log('✅ Respuesta exitosa (200):');
    console.log(JSON.stringify(response.data, null, 2));
  } catch (error) {
    if (error.response) {
      console.error(`❌ Error de la API (${error.response.status}):`);
      console.error(JSON.stringify(error.response.data, null, 2));
    } else {
      console.error('❌ Error de conexión:', error.message);
    }
  }
}

testLotteriesApi();
