// SPDX-License-Identifier: MIT
pragma solidity 0.8.30;

import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/access/Ownable.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/utils/ReentrancyGuard.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC20/IERC20.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/utils/Context.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/utils/math/Math.sol";
contract Presale is ReentrancyGuard, Context, Ownable {
    using Math for uint;
    mapping(address => uint) public _contributions;

    IERC20 public _token;
    uint private _tokenDecimals;
    address payable public _wallet;
    uint public _rate;
    uint public _weiRaised;
    uint public endICO;
    uint public availableTokensICO;

    event TokenPurchased(address purchaser, address beneficiary, uint value, uint amount);
    event Refund(address receipient, uint amount);

    modifier icoActive() {
        require(endICO > 0 && block.timestamp < endICO && availableTokensICO > 0, "ICO must be active");
        _;
    }

    modifier icoNotActive() {
        require(endICO < block.timestamp, "ICO should not be active");
        _;
    }

    constructor(uint rate, address payable wallet, IERC20 token, uint tokenDecimals) {
        require(rate > 0, "Presale rate must be > 0");
        require(wallet != address(0),"Presale wallet must be another address");
        require(address(token) != address(0), " Presale token address is wrong");

        _rate = rate;
        _wallet = wallet;
        _token = token;
        _tokenDecimals = 18 - tokenDecimals;
    }

    function startICO(uint endDate) external onlyOwner icoNotActive() {
        availableTokensICO = _token.balanceOf(address(this));
        require(endDate > block.timestamp, " duration must be > 0");
        require(availableTokensICO > 0, "availableTokensICO must be > 0");
        endICO = endDate;
        _weiRaised = 0;
    }

    function stopICO() external onlyOwner icoActive() {
        endICO = 0;
        _forwardFunds();
    }

    function buyTokens(address beneficiary) public nonReentrant icoActive payable {
        uint weiAmount = msg.value;
        uint tokens = _getTokenAmount(weiAmount);
        _weiRaised = _weiRaised + weiAmount;
        availableTokensICO = availableTokensICO - tokens;
        _contributions[beneficiary] = _contributions[beneficiary] + weiAmount;

        emit TokenPurchased(_msgSender(), beneficiary, weiAmount, tokens);
    }

    function _getTokenAmount(uint  weiAmount) internal view returns(uint) {
        return (weiAmount* _rate)/ (10 ** _tokenDecimals);
    }

    function claimTokens() external icoNotActive {
        uint tokensAmt = _getTokenAmount(_contributions[msg.sender]);
        _contributions[msg.sender] = 0;
        _token.transfer(msg.sender, tokensAmt);
    }

    function _forwardFunds() internal {
        _wallet.transfer(address(this).balance);
    }

    function withdraw() external onlyOwner icoNotActive {
        require(address(this).balance > 0, " there is no money in contract");
        _wallet.transfer(address(this).balance);
    }

    function checkContribution(address addr) public view returns (uint) {
        return _contributions[addr];
    }

    function setRate(uint newRate) external onlyOwner icoNotActive {
        _rate = newRate;
    }

    function setAvailableTokens(uint amount) external onlyOwner icoNotActive {
        availableTokensICO = amount;
    }

    function weiRaised() external view returns (uint) {
        return _weiRaised;
    }

    function setNewWallet(address payable newWallet) external onlyOwner {
        _wallet = newWallet;
    }

    function takeTokens(IERC20 tokenAddress) public onlyOwner icoNotActive {
        IERC20 tokenERC20 = tokenAddress;
        uint tokenAmt = tokenERC20.balanceOf(address(this));
        require(tokenAmt > 0, "balance is not enough");
        tokenERC20.transfer(_wallet, tokenAmt);
    }


}
