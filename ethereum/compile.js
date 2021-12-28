const path = require('path');
const solc = require('solc');
const fs = require('fs-extra');//used to get address of file system module

//delete entire build folder
const buildPath = path.resolve(__dirname, 'build');
fs.removeSync(buildPath);

//read FakeNews.sol from the contract folder
const fakenewsPath = path.resolve(__dirname,'contract', 'FakeNews.sol');
const source = fs.readFileSync(fakenewsPath, 'utf-8');
const output = solc.compile(source, 1).contracts;

//create build folder
fs.ensureDirSync(buildPath); //create build folder

console.log(output);
for(let contract in output){
    fs.outputJSONSync(
        path.resolve(buildPath, contract.replace(':', '') + ".json"),
        output[contract]
    );
}
