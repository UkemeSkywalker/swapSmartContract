// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/utils/math/SafeMath.sol";
import "./IERC20Interface.sol";


contract swapERC20Token { 

    address public owner;
    address public tokenContract;
    bool public pause;


    mapping(bytes32 => address) tokens;
    mapping(bytes32 => uint256) tokensPrice;
    mapping(bytes32 => address) tokensBurn;
    mapping(bytes32 => uint256) tokensDecimals;
 
    IERC20 public IERC20SwapInterface;
    // ERC20 public 
    IERC20Interface public ERC20Interface;




    modifier onlyOwner {
        require(owner == msg.sender);
        _;
    }


    constructor() {
        owner = msg.sender;
    }


    
    function addPause(bool _state) public onlyOwner returns(bool){
        pause = _state;
    }



    function addNewToken(bytes23 symbol_, address address_) public onlyOwner returns(bool){
        tokens[symbol_] = address_;
        return true;
    }

    function addPrice(bytes32 symbol_, uint256 price_) public onlyOwner returns(bool){
        tokensPrice[symbol_] = price_;
    }

    function addDecimal(bytes32 symbol_, uint decimals) public onlyOwner returns(bool){
        tokensDecimals[symbol_] = 10**uint(decimals);
    }

    
    function returnPrice(bytes32  symbol_) public view returns(uint256){
        return(tokensPrice[symbol_]);
    }

    function returnSymbol(bytes32 symbol_)public view returns(address){
        return(tokens[symbol_]);
    }

    function returnBurnAddress(bytes32 symbol_) public view returns(address){
        return(tokensBurn[symbol_]);
    }

    function returnDecimals(bytes32 symbol_) public view returns(uint256){
        return(tokensDecimals[symbol_]);
    }

    function forContract(address address_) public onlyOwner{
        tokenContract = address_;
    }




      function swapToken(bytes32 symbol_, uint256 amount_) public {
        require(pause == false);
        require(tokens[symbol_]!= address(0));
        require(amount_ > 0);

        address contract_ = tokens[symbol_];
        uint256 tPrice_ = tokensPrice[symbol_];
        uint256 decimalsR = tokensDecimals[symbol_];
        address burnAddress = tokensBurn[symbol_];
        address from_ = msg.sender;

         if(amount_ > IERC20SwapInterface.allowance(from_, address(this))){
            revert();
        }

        uint256 totalTokens_ = SafeMath.mul(SafeMath.div(amount_,tPrice_),decimalsR);

        IERC20SwapInterface.transferFrom(from_, burnAddress, amount_);



    
    }
}