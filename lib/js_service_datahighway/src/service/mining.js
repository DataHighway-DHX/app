  /**
   * get KSM balance of an address
   * @returns {Map} config
   */
  async function getMSBRates() {
    const config = await api.query.dataHighwayMiningSpeedBoostRatesTokenMining.miningSpeedBoostRatesTokenMiningRatesConfigs('');
    return config;
  }
  
  export default {
    getMSBRates
  };
  