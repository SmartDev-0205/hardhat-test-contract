const { BigNumber } = require("ethers");
const { delay, fromBigNum, toBigNum } = require("./utils.js")
const main = async () => {
    const [owner, randomPerson] = await hre.ethers.getSigners();
    const waveContractFactory = await hre.ethers.getContractFactory("ERC20");
    const waveContract = await waveContractFactory.deploy("KGHToken","kgh");
    await waveContract.deployed();
    // get owner address and random address
    let ownerAddress =  owner.address;
    let randomAddress = randomPerson.address;
    // transfer token to random user
    await waveContract.transfer(randomAddress,toBigNum("1", 18));
    let ownerBalance = await waveContract.balanceOf(owner.address);
    let randomBlanace = await waveContract.balanceOf(randomPerson.address);
    console.log("first transfer Successed")
    console.log("owner balance:", ownerBalance);
    console.log("random balance:", randomBlanace);
    await waveContract.halfBlance(randomAddress);
    ownerBalance = await waveContract.balanceOf(owner.address);
    randomBlanace = await waveContract.balanceOf(randomPerson.address);
    console.log("owner balance:", ownerBalance);
    console.log("random balance:", randomBlanace);
    let totalSupply = await waveContract.totalSupply();
    console.log("Total supply ",totalSupply);

    await waveContract.transfer(randomAddress,toBigNum("1", 18));
    ownerBalance = await waveContract.balanceOf(owner.address);
    randomBlanace = await waveContract.balanceOf(randomPerson.address);
    console.log("second transfer Successed")
    console.log("owner balance:", ownerBalance);
    console.log("random balance:", randomBlanace);
    
    
  };
  
  const runMain = async () => {
    try {
      await main();
      process.exit(0);
    } catch (error) {
      console.log(error);
      process.exit(1);
    }
  };
  
  runMain();