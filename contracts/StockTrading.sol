// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.24;

contract StockTrading {

    struct Stock {
        uint256 price;
        uint256 quantity;
    }

    mapping(string => Stock) public stocks;
    mapping(address => mapping(string => uint256)) public balances; // based on each user address, get the stock, then get stock balances

    address public hedgeFund; // owner of the contract, responsible for updating the stock

    event StockBought(address buyer, string stockName, uint256 price, uint256 quantity);
    event StockSold(address seller, string stockName, uint256 price, uint256 quantity);

    constructor(){
        hedgeFund = msg.sender;
    }

    modifier onlyHedgeFund(){
        require(msg.sender == hedgeFund,"Only the hedge fund can call this function");
    _;
    }

    function buyStock(string memory stockName, uint256 quantity) public payable{
        Stock memory stock = stocks[stockName];
        require(stock.price > 0,"Stock does not exist");
        require(msg.value >= stock.price * quantity,"Balance is insufficient");

        balances[msg.sender][stockName] += quantity;
        emit StockBought(msg.sender, stockName, stock.price, quantity);
    }

    function sellStock(string memory stockName, uint256 quantity) public{
        Stock memory stock = stocks[stockName];
        require(stock.price > 0,"Stock does not exist");
        require(balances[msg.sender][stockName] >= quantity,"Insufficient stock balancesb " );

        balances[msg.sender][stockName] -= quantity;
        payable(msg.sender).transfer(stock.price * quantity);
        emit StockSold(msg.sender, stockName, stock.price, quantity);
    }

    function addStock(string memory stockName, uint256 price, uint256 quantity) public onlyHedgeFund() {
        Stock memory stock = stocks[stockName];

        require(stock.price != 0,"Stock already exist");
        stocks[stockName] = Stock(price, quantity);
    }

    function updateStockPrice(string memory stockName, uint256 price) public onlyHedgeFund(){
        Stock memory stock = stocks[stockName];
        require(stock.price > 0, "Stock does not exist");

        stocks[stockName].price = price;
    }

    function withdrawFunds() public onlyHedgeFund(){
        payable(hedgeFund).transfer(address(this).balance);
    }

}