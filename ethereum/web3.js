import Web3 from "web3";

//when using react we write window but as next js runs on server side at server we dont have window
// we have window only in browser
// hence we need to change this
// const web3 = new Web3(window.web3.currentProvider);

//remember our code is going to run/compile two time one at server in next.js server and one at browerser

let web3;

//check if we are running in browers/server , as in browers is window is avalable
//window.web3 !== 'undefined' this is checking if metamask is installed
if(typeof window !== 'undefined' && typeof window.web3 !== 'undefined'){
    //we are in browser and metamask is running
    web3 = new Web3(window.web3.currentProvider);
}else{
    // we are on the server OR the user is not running metamask
    // in this case we need to provide our own provider ans set it up using infura
    const provider = new Web3.providers.HttpProvider(
        'https://rinkeby.infura.io/v3/07bdfda7164242f0a5df060bef620802'
    );
    web3 = new Web3(provider);
}


export default web3;