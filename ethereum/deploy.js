const HDWalletProvider = require('truffle-hdwallet-provider');
const Web3 = require('web3');

//taking the compiled solc file from build
const compiledFactory = require('../ethereum/build/CampaignFactory.json');

const provider = new HDWalletProvider(
    'middle harbor tomorrow oak tape cage earn dismiss candy rare patch viable',
    'https://rinkeby.infura.io/v3/07bdfda7164242f0a5df060bef620802'
);

const web3 = new Web3(provider);

const deploy = async() =>{
    //get the list of all account
    const accounts = await web3.eth.getAccounts();
    console.log('Attempting to deploy from account', accounts[0]);

    //deploying contract
    const result = await new web3.eth.Contract(JSON.parse(compiledFactory.interface))
    .deploy({ data: compiledFactory.bytecode })
    .send({gas:'1000000', from: accounts[0]});

    console.log(compiledFactory.interface);
    console.log('Contract deployed to :- ',result.options.address);
};

deploy();

/* first deploy
Attempting to deploy from account 0x986AFFe5EF54151FE093Ee2C51FA163f6b1Ef508
[{"constant":true,"inputs":[],"name":"getDeployedCampaigns","outputs":[{"name":"","type":"address[]"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":true,"inputs":[{"name":"","type":"uint256"}],"name":"deployedContracts","outputs":[{"name":"","type":"address"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":false,"inputs":[{"name":"minimum","type":"uint256"}],"name":"createCampaign","outputs":[],"payable":false,"stateMutability":"nonpayable","type":"function"}]
Contract deployed to :-  0x9a97DAAe33a96492e461F40ee2e6d64ba5f95490
*/

/* second deploy
Attempting to deploy from account 0x986AFFe5EF54151FE093Ee2C51FA163f6b1Ef508
[{"constant":true,"inputs":[],"name":"getDeployedCampaigns","outputs":[{"name":"","type":"address[]"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":true,"inputs":[{"name":"","type":"uint256"}],"name":"deployedContracts","outputs":[{"name":"","type":"address"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":false,"inputs":[{"name":"minimum","type":"uint256"}],"name":"createCampaign","outputs":[],"payable":false,"stateMutability":"nonpayable","type":"function"}]
Contract deployed to :-  0xAfbb5ADCFa0D8468Fa9CD19037CcC7440D4AD8fA
*/