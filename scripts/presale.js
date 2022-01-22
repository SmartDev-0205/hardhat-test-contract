const { waffle } = require("hardhat");
const { BigNumber, ethers } = require("ethers");
const { delay, fromBigNum, toBigNum } = require("./utils.js")
const main = async() => {

    const [owner] = await hre.ethers.getSigners();
    var terms = {
        vestingPrice: 30000 * 1000000, // 300000 QE/ETH // 1e6
        vestingPeriod: 20 * 24 * 3600, // 20 days
        price: 3000 * 1000000 // 3000 QE/ETH // 1e6
    }

    terms.vestingPeriod += Number(((new Date()) / 1000).toFixed(0));

    let ownerAddress = owner.address;

    const provider = waffle.provider;
    const balance0ETH = await provider.getBalance(ownerAddress);
    console.log("ownerBlance", balance0ETH);
    const ERC20TOKEN = await hre.ethers.getContractFactory("ERC20");
    const tokenContract = await ERC20TOKEN.deploy("KGHToken", "kgh");
    await tokenContract.deployed();
    console.log("ERC Token deployed");
    const PresaleContract = await hre.ethers.getContractFactory("Presale");
    const presaleContract = await PresaleContract.deploy(tokenContract.address, owner.address, terms);
    console.log("Presale token deployed");
    // await presaleContract.buy({ value: ethers.utils.parseEther("0.5") });
    console.log("presale price", await presaleContract.getPrice());
};

const runMain = async() => {
    try {
        await main();
        process.exit(0);
    } catch (error) {
        console.log(error);
        process.exit(1);
    }
};

runMain();
runMain();