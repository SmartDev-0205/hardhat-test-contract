//This is tokenomics
// 6% tax
// Split as follows:
// 4% to our property purchase wallet paid out in BUSD
// 2% back to holders paid out in BUSD
// These paid out daily or every 6 hours.
// 3% of total supply whale wallet limit.
// Would be nice if we could figure out a way to prevent that tax when staking tokens.
// 4:55
// BEP20 contract

// Symbol: HMRN
// Total Supply: 500,000,000
// Decimals: 9
// Property Tax
//         Received In: BUSD
//         Address: 0x1C31D26B397b5A212393cb396bE06909035463A7
// % Break-downs:
//         Presale: 4.4%
//         Team/Advisor: 18%
//         Marketing Wallet: 4%
//         Charity Wallet: 1%
//         Liquidity Pools: 20%
//         Community Appreciation Wallet: 2%
//         Locked for 2 years for debit card: 50.6%
pragma solidity ^0.8;

interface IERC20 {
	/**
	 * @dev Returns the amount of tokens in existence.
	 */
	function totalSupply() external view returns (uint);

	/**
	 * @dev Returns the token decimals.
	 */
	function decimals() external view returns (uint8);

	/**
	 * @dev Returns the token symbol.
	 */
	function symbol() external view returns (string memory);

	/**
	* @dev Returns the token name.
	*/
	function name() external view returns (string memory);

	/**
	 * @dev Returns the bep token owner.
	 */
	function getOwner() external view returns (address);

	/**
	 * @dev Returns the amount of tokens owned by `account`.
	 */
	function balanceOf(address account) external view returns (uint);

	/**
	 * @dev Moves `amount` tokens from the caller's account to `recipient`.
	 *
	 * Returns a boolean value indicating whether the operation succeeded.
	 *
	 * Emits a {Transfer} event.
	 */
	function transfer(address recipient, uint amount) external returns (bool);

	/**
	 * @dev Returns the remaining number of tokens that `spender` will be
	 * allowed to spend on behalf of `owner` through {transferFrom}. This is
	 * zero by default.
	 *
	 * This value changes when {approve} or {transferFrom} are called.
	 */
	function allowance(address _owner, address spender) external view returns (uint);

	/**
	 * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
	 *
	 * Returns a boolean value indicating whether the operation succeeded.
	 *
	 * IMPORTANT: Beware that changing an allowance with this method brings the risk
	 * that someone may use both the old and the new allowance by unfortunate
	 * transaction ordering. One possible solution to mitigate this race
	 * condition is to first reduce the spender's allowance to 0 and set the
	 * desired value afterwards:
	 * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
	 *
	 * Emits an {Approval} event.
	 */
	function approve(address spender, uint amount) external returns (bool);

	/**
	 * @dev Moves `amount` tokens from `sender` to `recipient` using the
	 * allowance mechanism. `amount` is then deducted from the caller's
	 * allowance.
	 *
	 * Returns a boolean value indicating whether the operation succeeded.
	 *
	 * Emits a {Transfer} event.
	 */
	function transferFrom(address sender, address recipient, uint amount) external returns (bool);

	/**
	 * @dev Emitted when `value` tokens are moved from one account (`from`) to
	 * another (`to`).
	 *
	 * Note that `value` may be zero.
	 */
	event Transfer(address indexed from, address indexed to, uint value);

	/**
	 * @dev Emitted when the allowance of a `spender` for an `owner` is set by
	 * a call to {approve}. `value` is the new allowance.
	 */
	event Approval(address indexed owner, address indexed spender, uint value);
}

contract Context {
	// Empty internal constructor, to prevent people from mistakenly deploying
	// an instance of this contract, which should be used via inheritance.
	// constructor() internal { }

	function _msgSender() internal view returns (address ) {
		return msg.sender;
	}

	function _msgData() internal view returns (bytes memory) {
		this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
		return msg.data;
	}
}

library SafeMath {

	function add(uint a, uint b) internal pure returns (uint) {
		uint c = a + b;
		require(c >= a, "SafeMath: addition overflow");

		return c;
	}

	function sub(uint a, uint b) internal pure returns (uint) {
		return sub(a, b, "SafeMath: subtraction overflow");
	}

	function sub(uint a, uint b, string memory errorMessage) internal pure returns (uint) {
		require(b <= a, errorMessage);
		uint c = a - b;

		return c;
	}

	function mul(uint a, uint b) internal pure returns (uint) {
		
		if (a == 0) {
			return 0;
		}

		uint c = a * b;
		require(c / a == b, "SafeMath: multiplication overflow");

		return c;
	}

	function div(uint a, uint b) internal pure returns (uint) {
		return div(a, b, "SafeMath: division by zero");
	}

	function div(uint a, uint b, string memory errorMessage) internal pure returns (uint) {
		// Solidity only automatically asserts when dividing by 0
		require(b > 0, errorMessage);
		uint c = a / b;
		// assert(a == b * c + a % b); // There is no case in which this doesn't hold

		return c;
	}

	function mod(uint a, uint b) internal pure returns (uint) {
		return mod(a, b, "SafeMath: modulo by zero");
	}

	function mod(uint a, uint b, string memory errorMessage) internal pure returns (uint) {
		require(b != 0, errorMessage);
		return a % b;
	}
}

contract Ownable is Context {
	address private _owner;

	event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);

	constructor() public {
		address msgSender = _msgSender();
		_owner = msgSender;
		emit OwnershipTransferred(address(0), msgSender);
	}

	function owner() public view returns (address) {
		return _owner;
	}

	modifier onlyOwner() {
		require(_owner == _msgSender(), "Ownable: caller is not the owner");
		_;
	}

	function renounceOwnership() public onlyOwner {
		emit OwnershipTransferred(_owner, address(0));
		_owner = address(0);
	}

	function transferOwnership(address newOwner) public onlyOwner {
		_transferOwnership(newOwner);
	}

	function _transferOwnership(address newOwner) internal {
		require(newOwner != address(0), "Ownable: new owner is the zero address");
		emit OwnershipTransferred(_owner, newOwner);
		_owner = newOwner;
	}
}

contract Mintable is Ownable {
	mapping(address => bool) public isMinters;
	address[] public minters;
	// string[] public poolNames;

	event SetMinters(address indexed newMinter,bool isMinter);

	function setMinter(address _newMinter) public onlyOwner {
		isMinters[_newMinter] = true;
		minters.push(_newMinter);
		emit SetMinters(_newMinter,true);
	}
	function setMinters(address[] memory _minters) external onlyOwner {
		for(uint i=0; i<_minters.length; i++) {
			setMinter(_minters[i]);
		}
	}
	function disableMinter(address _minter) external onlyOwner {
		isMinters[_minter] = false;
		emit SetMinters(_minter,false);
	}

	modifier onlyMinter() {
		require(isMinters[msg.sender] == true || msg.sender==owner(), "Mintable: caller is not the minter");
		_;
	}

}

interface IPancakeswapFactory {
		event PairCreated(address indexed token0, address indexed token1, address pair, uint);

		function feeTo() external view returns (address);
		function feeToSetter() external view returns (address);

		function getPair(address tokenA, address tokenB) external view returns (address pair);
		function allPairs(uint) external view returns (address pair);
		function allPairsLength() external view returns (uint);

		function createPair(address tokenA, address tokenB) external returns (address pair);

		function setFeeTo(address) external;
		function setFeeToSetter(address) external;
}

interface IPancakeswapPair {
		event Approval(address indexed owner, address indexed spender, uint value);
		event Transfer(address indexed from, address indexed to, uint value);

		function name() external pure returns (string memory);
		function symbol() external pure returns (string memory);
		function decimals() external pure returns (uint8);
		function totalSupply() external view returns (uint);
		function balanceOf(address owner) external view returns (uint);
		function allowance(address owner, address spender) external view returns (uint);

		function approve(address spender, uint value) external returns (bool);
		function transfer(address to, uint value) external returns (bool);
		function transferFrom(address from, address to, uint value) external returns (bool);

		function DOMAIN_SEPARATOR() external view returns (bytes32);
		function PERMIT_TYPEHASH() external pure returns (bytes32);
		function nonces(address owner) external view returns (uint);

		function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;

		event Mint(address indexed sender, uint amount0, uint amount1);
		event Burn(address indexed sender, uint amount0, uint amount1, address indexed to);
		event Swap(
				address indexed sender,
				uint amount0In,
				uint amount1In,
				uint amount0Out,
				uint amount1Out,
				address indexed to
		);
		event Sync(uint112 reserve0, uint112 reserve1);

		function MINIMUM_LIQUIDITY() external pure returns (uint);
		function factory() external view returns (address);
		function token0() external view returns (address);
		function token1() external view returns (address);
		function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
		function price0CumulativeLast() external view returns (uint);
		function price1CumulativeLast() external view returns (uint);
		function kLast() external view returns (uint);

		function mint(address to) external returns (uint liquidity);
		function burn(address to) external returns (uint amount0, uint amount1);
		function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
		function skim(address to) external;
		function sync() external;

		function initialize(address, address) external;
}

interface IPancakeswapRouter{
		function factory() external pure returns (address);
		function WETH() external pure returns (address);

		function addLiquidity(
				address tokenA,
				address tokenB,
				uint amountADesired,
				uint amountBDesired,
				uint amountAMin,
				uint amountBMin,
				address to,
				uint deadline
		) external returns (uint amountA, uint amountB, uint liquidity);
		function addLiquidityETH(
				address token,
				uint amountTokenDesired,
				uint amountTokenMin,
				uint amountETHMin,
				address to,
				uint deadline
		) external payable returns (uint amountToken, uint amountETH, uint liquidity);
		function removeLiquidity(
				address tokenA,
				address tokenB,
				uint liquidity,
				uint amountAMin,
				uint amountBMin,
				address to,
				uint deadline
		) external returns (uint amountA, uint amountB);
		function removeLiquidityETH(
				address token,
				uint liquidity,
				uint amountTokenMin,
				uint amountETHMin,
				address to,
				uint deadline
		) external returns (uint amountToken, uint amountETH);
		function removeLiquidityWithPermit(
				address tokenA,
				address tokenB,
				uint liquidity,
				uint amountAMin,
				uint amountBMin,
				address to,
				uint deadline,
				bool approveMax, uint8 v, bytes32 r, bytes32 s
		) external returns (uint amountA, uint amountB);
		function removeLiquidityETHWithPermit(
				address token,
				uint liquidity,
				uint amountTokenMin,
				uint amountETHMin,
				address to,
				uint deadline,
				bool approveMax, uint8 v, bytes32 r, bytes32 s
		) external returns (uint amountToken, uint amountETH);
		function swapExactTokensForTokens(
				uint amountIn,
				uint amountOutMin,
				address[] calldata path,
				address to,
				uint deadline
		) external returns (uint[] memory amounts);
		function swapTokensForExactTokens(
				uint amountOut,
				uint amountInMax,
				address[] calldata path,
				address to,
				uint deadline
		) external returns (uint[] memory amounts);
		function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
				external
				payable
				returns (uint[] memory amounts);
		function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
				external
				returns (uint[] memory amounts);
		function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
				external
				returns (uint[] memory amounts);
		function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
				external
				payable
				returns (uint[] memory amounts);

		function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
		function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
		function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
		function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
		function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
		function removeLiquidityETHSupportingFeeOnTransferTokens(
			address token,
			uint liquidity,
			uint amountTokenMin,
			uint amountETHMin,
			address to,
			uint deadline
		) external returns (uint amountETH);
		function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
			address token,
			uint liquidity,
			uint amountTokenMin,
			uint amountETHMin,
			address to,
			uint deadline,
			bool approveMax, uint8 v, bytes32 r, bytes32 s
		) external returns (uint amountETH);
	
		function swapExactTokensForTokensSupportingFeeOnTransferTokens(
			uint amountIn,
			uint amountOutMin,
			address[] calldata path,
			address to,
			uint deadline
		) external;
		function swapExactETHForTokensSupportingFeeOnTransferTokens(
			uint amountOutMin,
			address[] calldata path,
			address to,
			uint deadline
		) external payable;
		function swapExactTokensForETHSupportingFeeOnTransferTokens(
			uint amountIn,
			uint amountOutMin,
			address[] calldata path,
			address to,
			uint deadline
		) external;
}

interface IStoreContract {
	function withDraw(address tokenAddress) external ;
}
interface IStaking {
	function stakeTokenAddress() external view returns(address);
	function getStakeInfo(address stakerAddress) external view returns(uint _total, uint _staking, uint _rewardable, uint _rewards);
	function countTotalStake() external view returns (uint _totalStake);
	function countTotalReward() external view returns (uint _totalReward);
}

// Homerun Token Token contract written by Galaxy Foundation Team bussiness email:xhe18623@gmail.com
contract HMRN is Context, IERC20, Mintable {
	using SafeMath for uint;

	mapping (address => uint) private _balances;

	mapping (address => mapping (address => uint)) private _allowances;
	//Presale Event for emit on website
	event Presaled (
		address user,
		uint usdtAmount,
		uint dMtokenAmount
	);

	
	uint8 private _decimals = 9;
	string private _symbol = "HMRN";
	string private _name = "Homerun Token";
	uint private _maxSupply = 5 *1e8 * 1e9; // maxsupply
	uint private _totalSupply = 0; // 5*1e8 * 10 ** 9; // presale amout

	uint public totalFee = 600; // Me
	uint public purcaseFee = 400;  // Me
	uint public holdersFee = 200; // Me
	address public purcaseWallet = 0x1C31D26B397b5A212393cb396bE06909035463A7; // Me
	uint public limitPerWallet = 300; // Me

	address public teamWallet = 0x7f58A98B9F3bB6bec31FDeb3d7E180B1E0697C96;
	address public marketingWallet= 0xF7D342f6A4482502C653d896E35222480264f4c8;
	address public charityWallet=0xC0006C10e05e7AaB05320603cbC4A4Dc3e50CeC5;
	address public lockWallet =0xA94413a5fFf6Af5a988b89c2AA38F5A9b19DF47F;
	address public communityWallet=0x582A33A7863dAb65A40C19Cf6DF723d781af43E2;

	uint tokenLocked=0;

	uint private ratePresale = 440;
	uint private rateTeam = 1800;
	uint private rateCharity = 100;
	uint private rateLiquidity = 2000;
	uint private rateMarketing = 400;
	uint private rateCommunity = 200;
	uint private rateLock = 5060;

	bool public swapAndLiquifyEnabled = true;
	uint public minLiquidityAmount = 1e3 * 1e18;

	IPancakeswapRouter public pancakeswapRouter;
	address public pancakeswapMDUSDTPair;
	address public USDTAddress;
	address public stakingAddress;
	address public storeAddress;

	bool inSwapAndLiquify;
	modifier lockTheSwap {
		inSwapAndLiquify = true;
		_;
		inSwapAndLiquify = false;
	}

	bool inRedeem;
	modifier lockRedeem {
		inRedeem = true;
		_;
		inRedeem = false;
	}

	uint startTime;

	constructor() public {
		_mint(teamWallet, 		_maxSupply.mul(rateTeam).div(1e4));
		_mint(marketingWallet, 	_maxSupply.mul(rateMarketing).div(1e4));
		_mint(charityWallet, 	_maxSupply.mul(rateCharity).div(1e4));
		_mint(lockWallet, 		_maxSupply.mul(rateLock).div(1e4));
		_mint(communityWallet, 	_maxSupply.mul(rateCommunity).div(1e4));
		_mint(address(this), 	_maxSupply.mul(ratePresale).div(1e4));
		tokenLocked = block.timestamp + 2 * 365  days;
	}

	function setSwapAndLiquifyEnabled(bool enable) external onlyOwner {
		swapAndLiquifyEnabled = enable;
	}

	function setInitialAddresses(address _purcaseWallet, address _RouterAddress, address _USDTAddress, address _storeAddress, address _stakingAddress) external onlyOwner {
		purcaseWallet = _purcaseWallet;
		stakingAddress = _stakingAddress;
		storeAddress = _storeAddress;
		USDTAddress = _USDTAddress;
		IPancakeswapRouter _pancakeswapRouter = IPancakeswapRouter(_RouterAddress);
		pancakeswapRouter = _pancakeswapRouter;
		pancakeswapMDUSDTPair = IPancakeswapFactory(_pancakeswapRouter.factory()).createPair(address(this), _USDTAddress);
	}
	//Contract owner modifies rate settings
	function setFees(uint _purcaseFee, uint _holdersFee, uint _limitPerWallet) external onlyOwner {
		purcaseFee = _purcaseFee;
		holdersFee = _holdersFee;
		limitPerWallet = _limitPerWallet;
	}

	function getOwner() external view override returns (address) {
		return owner();
	}

	function getTotalFee() public view returns (uint) {
		return (purcaseFee + holdersFee ); // Me
	}

	function decimals() external override view returns (uint8) {
		return _decimals;
	}

	function symbol() external override view returns (string memory) {
		return _symbol;
	}

	function name() external override view returns (string memory) {
		return _name;
	}

	function totalSupply() external override view returns (uint) {
		return _totalSupply;
	}

	function balanceOf(address account) public override view returns (uint) {
		return _balances[account];
	}

	function transfer(address recipient, uint amount) public override returns (bool) {
		_transfer(_msgSender(), recipient, amount);
		return true;
	}

	function allowance(address owner, address spender) external override view returns (uint) {
		return _allowances[owner][spender];
	}

	function approve(address spender, uint amount) external override returns (bool) {
		_approve(_msgSender(), spender, amount);
		return true;
	}

	function transferFrom(address sender, address recipient, uint amount) external override returns (bool) {
		_transfer(sender, recipient, amount);
		_approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "BEP20: transfer amount exceeds allowance"));
		return true;
	}

	function increaseAllowance(address spender, uint addedValue) public returns (bool) {
		_approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
		return true;
	}

	function decreaseAllowance(address spender, uint subtractedValue) public returns (bool) {
		_approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "BEP20: decreased allowance below zero"));
		return true;
	}

	function mint(uint amount) public onlyMinter returns (bool) {
		_mint(_msgSender(), amount);
		return true;
	}

	//Transfer function, buy without deduction, sell with deduction, there is a contract in the form of DM, once someone transfers each other, the DM is exchanged for USDT dividends.
	function _transfer(address sender, address recipient, uint amount) internal {
		require(sender != address(0), "BEP20: transfer from the zero address");
		require(recipient != address(0), "BEP20: transfer to the zero address");
		uint recieveAmount = amount;

		require(_balances[sender].add(presales[sender].unlocked).sub(presales[sender].amount)>=amount,"BEP20: transfer amount exceeds balance");
		_balances[sender] = _balances[sender].sub(amount, "BEP20: transfer amount exceeds balance");
		if (sender==lockWallet) {
            require(block.timestamp > tokenLocked, "Token was locked yet");
		}

		bool isBuy = sender==pancakeswapMDUSDTPair;
		bool isSell = recipient == pancakeswapMDUSDTPair;
		uint contractTokenBalance = _balances[address(this)];
		if (isSell) {
			// recieveAmount = amount.mul(10000 - totalFee).div(10000);
			uint feeAmount = amount.mul(totalFee).div(1e4);
			// uint purcaseFee = amount.mul(_purcaseFee).div(100);
			recieveAmount = amount.sub(feeAmount);

			contractTokenBalance = contractTokenBalance.add(feeAmount);//fees remained in Contract
			_balances[address(this)] = contractTokenBalance;
		}
		_balances[recipient] = _balances[recipient].add(recieveAmount);
		if (isBuy) {

			

			require(_balances[recipient] > _totalSupply.mul(limitPerWallet).div(1e4), "Whale Wallet limit"); // Me
		}
		//calculate DM reserved in this contract
		// uint contractTokenBalance = _balances[address(this)];
		//swap DM to usdt
		if (!inSwapAndLiquify && !inRedeem && !isBuy && !isSell && swapAndLiquifyEnabled) {
			if(minLiquidityAmount <= contractTokenBalance){
				swapAndLiquify();
			}
			//if price < some threshold number. admin open redeem switch.
			if (redeemable()) {
				redeem();
			}
		}

		emit Transfer(sender, recipient, recieveAmount);
	}
	
	//swap reserved DM in contract to USDT and some part of them to liquidty.
 	function swapAndLiquify() internal lockTheSwap {
		
		uint contractTokenBalance = _balances[address(this)];

		uint initialBalance = IERC20(USDTAddress).balanceOf(address(this));
		swapTokensForUSDT(contractTokenBalance);
		uint cBalance = IERC20(USDTAddress).balanceOf(address(this)).sub(initialBalance);
		uint holderRewards = cBalance.mul(holdersFee).div(totalFee);
		rewardPoolBalance = rewardPoolBalance.add(holderRewards);

	
		IERC20(USDTAddress).transfer(purcaseWallet, cBalance.sub(holderRewards));
		

 	}

	//invoke pancake router swap DM To USDT
	function swapTokensForUSDT(uint tokenAmount) internal {
		address[] memory path = new address[](2);
		path[0] = address(this);
		path[1] = USDTAddress;

		_approve(address(this), address(pancakeswapRouter), tokenAmount);

		// make the swap

		pancakeswapRouter.swapExactTokensForTokensSupportingFeeOnTransferTokens(
			tokenAmount,
			0, // accept any amount of usdt
			path,
			storeAddress,
			block.timestamp
		);

		IStoreContract(storeAddress).withDraw(USDTAddress);
	}

	function addLiquidity(uint tokenAmount, uint usdtAmount) private {
		// approve token transfer to cover all possible scenarios
		_approve(address(this), address(pancakeswapRouter), tokenAmount);
		IERC20(USDTAddress).approve(address(pancakeswapRouter),usdtAmount);

		// add the liquidity
		pancakeswapRouter.addLiquidity(
			address(this),
			USDTAddress,
			tokenAmount,
			usdtAmount,
			0, // slippage is unavoidable
			0, // slippage is unavoidable
			owner(),
			block.timestamp
		);
	}

	function _mint(address account, uint amount) internal {
		require(account != address(0), "BEP20: mint to the zero address");
		require(_totalSupply < _maxSupply, "exceed max supply");

		_totalSupply = _totalSupply.add(amount);
		_balances[account] = _balances[account].add(amount);
		emit Transfer(address(0), account, amount);
	}

	function _burn(address account, uint amount) internal {
		require(account != address(0), "BEP20: burn from the zero address");

		_balances[account] = _balances[account].sub(amount, "BEP20: burn amount exceeds balance");
		_totalSupply = _totalSupply.sub(amount, "BEP20: burn amount exceeds balance");
		emit Transfer(account, address(0), amount);
	}

	function _approve(address owner, address spender, uint amount) internal {
		require(owner != address(0), "BEP20: approve from the zero address");
		require(spender != address(0), "BEP20: approve to the zero address");

		_allowances[owner][spender] = amount;
		emit Approval(owner, spender, amount);
	}

	function _burnFrom(address account, uint amount) internal {
		_burn(account, amount);
		_approve(account, _msgSender(), _allowances[account][_msgSender()].sub(amount, "BEP20: burn amount exceeds allowance"));
	}

	/* =========== presale & rewards Pre-sale dividend function=========== */

	event ClaimReward(address user,uint amount);
	event Unlocked(address user,uint amount,uint timeStamp);

	uint public rewardPoolBalance;
	uint public rewardedTotalBalance;
	// mapping(address=>uint) rewardedBalance;

	uint public USDTDecimals = 18;

	uint public presalePrice = 5 * 10 ** (USDTDecimals - 3);
	
	uint public presaleLimit1 = 200 * 10 ** uint(_decimals) * 10 ** USDTDecimals / presalePrice; // is dmtoken
	uint public presaleLimit2 = 3000 * 10 ** uint(_decimals) * 10 ** USDTDecimals / presalePrice; // is dmtoken

	uint public presaledTotal; // is dmtoken
	uint public presaleTotal = 250 * 1e6 * 10 ** uint(_decimals); // is dmtoken Maximum number of pre-sold DM tokens

	uint public presaleEndTime = 1637510400; // 20 days
	struct Presale {
		uint amount; // is dm.
		uint unlocked; // is dm.
		uint rewards; // is usdt
	}


	mapping(address=>Presale) public presales;

	struct RewardType {
		uint lasttime; // is dm.
		uint rewards; // is usdt
	}


	mapping(address=>RewardType) public rewards;

		
	uint[][] unlockSteps = [
		[uint(8),   uint(40 days)],
		[uint(18),  uint(90 days)],
		[uint(30),  uint(150 days)],
		[uint(45),  uint(210 days)],
		[uint(62),  uint(270 days)],
		[uint(80),  uint(330 days)],
		[uint(100), uint(360 days)]
	];

	uint public referralRate = 12;
	//referal rate
	function setReferralRate(uint _referralRate) external onlyOwner {
		referralRate = _referralRate;
	}

	function presale(uint _usdt,address referral) public {
		address _sender = msg.sender;
		//calculate quanity to receive
		uint _quantity = _usdt * 10 ** 18 / presalePrice;

		require(_sender!=address(0), "_sender can't be zero address");
		require(presaleTotal > _quantity && block.timestamp < presaleEndTime,"presale ended");
		require(presaleLimit1 <= presales[_sender].amount + _quantity, "_sender must be greater or equals than limit1");
		require(presaleLimit2 >= presales[_sender].amount + _quantity, "presale total must be less or equals than limit2");
		//send USDT fund from invesotr to Contract Owner
		// IERC20(USDTAddress).transferFrom(_sender, feeAddress, _usdt);
		_mint(_sender, _quantity);//mint equal amount of DM token
		if(referral!=address(0)) {
			_mint(referral, _quantity.mul(referralRate).div(100));
			presales[referral].amount += _quantity.mul(referralRate).div(100);//lump sum DM token minted
			presaleTotal -= _quantity.mul(referralRate).div(100);
			presaledTotal += _quantity.mul(referralRate).div(100);

			emit Presaled(referral, _usdt.mul(referralRate).div(100), _quantity.mul(referralRate).div(100));
			}

		presales[_sender].amount += _quantity;//lump sum DM token minted
		presaleTotal -= _quantity;
		presaledTotal += _quantity;

		emit Presaled(_sender, _usdt, _quantity);
	}
	//private sale investor can claim USDT reward from USDT dividens pool
	function claimReward() external {
		address _sender = msg.sender;
		require(_sender!=address(0), "sender can't be zero");
		require(block.timestamp > rewards[_sender].lasttime + 6 hours, "paid out every 6 hourse"); 

		uint rewardBalance = getReward(_sender);
		require(rewardBalance > 0,"Claim : There is no reward amount");
		
		IERC20(USDTAddress).transfer(_sender, rewardBalance);
		rewards[_sender].rewards += rewardBalance;
		rewards[_sender].lasttime = block.timestamp;

		rewardPoolBalance -= rewardBalance;
		rewardedTotalBalance += rewardBalance;
	    
		emit ClaimReward(_sender, rewardBalance);
	}
	//caculate the reward for specified user. Formula =>  percentage(user invested)* pool(usdt)
	function getReward(address account) public view returns (uint ) {
		address _sender = msg.sender;

		if (_totalSupply>0) {

            uint rewardBalance;
			 rewardBalance = rewardPoolBalance.add(rewardedTotalBalance).mul(_balances[account]).div(_totalSupply);			
			if (rewardBalance > rewards[_sender].rewards) {
				return rewardBalance - rewards[_sender].rewards;
			}
		}
		return 0;
	}

	//user manaully unlock the DM amount
	function unlock() external {
		address _sender = msg.sender;
		uint _unlockAmount = getUnlockAmount(_sender);
		require(_sender!=address(0), "sender can't be zero");
		require(_unlockAmount>0, "_unlockAmount is zero");
		presales[_sender].unlocked += _unlockAmount;

		// uint timeStamp = block.timestamp;
		emit Unlocked(_sender, _unlockAmount, block.timestamp);
	}

	//getUnlock Amount user
	function getUnlockAmount(address account) public view returns (uint){
		if (account==0x0000000000000000000000000000000000000000) return 0;
		uint time = block.timestamp;
		for(uint i = unlockSteps.length - 1; i > 0; i--) {
			if (time > startTime + unlockSteps[i][1]) {
				return presales[account].amount * unlockSteps[i][0] / 100 - presales[account].unlocked;
			}
		}
		return 0;
	}
	/* ======================================== */

	function emergencyWithdraw(address token) external onlyOwner {
		uint tokenBalance = IERC20(token).balanceOf(address(this));
		IERC20(token).transfer(owner(), tokenBalance);
		rewardPoolBalance = 0;
		insurancePoolBalance = 0;
	} 
	
	/* ======================================== */

	function getStakerInfo(address account) external view returns (bool isEnd, uint[15] memory params, uint[36] memory pools, bool isFirst){
		uint i=0;
		// uint limit1, uint limit2, uint remainder, uint reward, uint dmBalance, uint usdtBalance, uint unlockable
		uint _locked = presales[account].amount;

		isEnd = block.timestamp > presaleEndTime;

		params[i++] = presaleEndTime; 		 		//presale endtime
		params[i++] = _locked > 0 ? 0 : presaleLimit1; 			//limit1
		params[i++] = presaleLimit2 - _locked; 					//limit2
		params[i++] = presaleTotal; 							//remainder
		params[i++] = getReward(account); 						//reward
		params[i++] = _balances[account]; 						//dmBalance
		params[i++] = account==0x0000000000000000000000000000000000000000 ? 0 : IERC20(USDTAddress).balanceOf(account); 	//usdtBalance
		params[i++] = getUnlockAmount(account); 				//unlockable
		params[i++] = rewardPoolBalance;
		params[i++] = rewardedTotalBalance;
		params[i++] = insurancePoolBalance;
		params[i++] = insurancePoolBurnt;


		// var pairAddress = await DMTokenContract.pancakeswapMDUSDTPair();
		params[i++] = IERC20(USDTAddress).balanceOf(pancakeswapMDUSDTPair);
		params[i++] = _balances[pancakeswapMDUSDTPair];
		params[i++] = _balances[address(this)];


		i=0;
		//this investors statistic in each pool infos.
		for(uint k=0; k<minters.length; k++) {
			(uint _total, uint _staking, uint _rewardable, ) = IStaking(minters[k]).getStakeInfo(account);
			pools[i++] = _total;
			pools[i++] = _staking;
			pools[i++] = _rewardable;
			pools[i++] = uint(IERC20(IStaking(minters[k]).stakeTokenAddress()).decimals());
		}
		isFirst = IPancakeswapPair(pancakeswapMDUSDTPair).token0() == address(this);
	}




	uint public insurancePoolBalance;
	uint public insurancePoolBurnt;
	//Check whether the repurchase conditions are met. 4. When the insurance pool reaches 100,000 USDT, 50% of the funds will be used to automatically repurchase the DM and burn (Homerun Token-USDT) trading pair.
	function redeemable() internal view returns(bool) {
		return insurancePoolBalance >= 1e5 * 10 ** uint(USDTDecimals);
	}
	//When the insurance pool reaches 100,000 USDT, 50% of the funds will be used to automatically repurchase DM and destroy the (Homerun Token-USDT) trading pair
	function redeem() internal lockRedeem{
        require(redeemable(), "not enought insurance pool balance");

        uint swapAmount = insurancePoolBalance.div(2);//50% amount USDT buy back
        address[] memory path = new address[](2);
        path[0] = USDTAddress;
        path[1] = address(this);
        IERC20(USDTAddress).approve(address(pancakeswapRouter), swapAmount);
		uint256 _initbalance = _balances[address(this)];
        // make the swap
        pancakeswapRouter.swapExactTokensForTokens(
            swapAmount,
            0, // accept any amount of ETH
            path,
            storeAddress,
            block.timestamp
        );

		_balances[address(this)] += _balances[storeAddress];
		_balances[storeAddress] = 0;

		insurancePoolBalance -= swapAmount;
		uint256 swapedAmount = _balances[address(this)].sub(_initbalance);
		insurancePoolBurnt += swapedAmount;
		_burn(address(this), swapedAmount);
        
    }
}