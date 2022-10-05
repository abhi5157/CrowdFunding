// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

// An online book Store where we create or sell book by own without third party
contract BookStore{
  address payable storeOwner;
  uint public fund;
  uint public capacity;
  uint public Store_openning_date;
  constructor (address payable owner, uint _fund, uint _capacity){
    storeOwner = owner;
     fund = _fund;
     capacity = _capacity;
      Store_openning_date = block.timestamp;
  }
  
  // function transfer(address payable _to, uint _amount) public  { 

  //       _to.transfer(_amount);
  //   }

struct Seller{
address SellerAdd;
string bookName; 
uint date;
uint demandPrice;
uint bookNo;
}
mapping(uint => Seller) store;
uint public seller_count;
mapping(address => uint) seller_store;
modifier Condition{
  require(Store_openning_date < block.timestamp,"Store are still closed try Later");
  _;
}

function SellBook(string memory _bookName, uint _demandPrice, uint _bookNo) external Condition {
 require(_demandPrice < fund, "No available Fund for the Buying New Product");
 require(address(storeOwner).balance > fund , "No available Fund for the Buying New Product");
  require(msg.sender !=storeOwner, "You can't buy Product from your own Store");
   require(_bookNo < capacity , "No available Space for new book");
//  storeOwner.transfer(_demandPrice);

store[_bookNo] = Seller(msg.sender, _bookName,block.timestamp, _demandPrice,_bookNo);
seller_count++;
seller_store[msg.sender] = seller_count;
}

mapping(address =>mapping(uint=> Seller)) Buyer;
mapping(address => uint) buyer_store;
uint public  buyer_count;

function BuyBook(uint id, uint price) public  Condition payable{

  Seller storage Details = store[id];
  require(address(msg.sender).balance >price , "Not enough money to buy book");
  require(price > Details.demandPrice, "If it is small then this we won't get profit");
 storeOwner.transfer(price);
  Buyer[msg.sender][id] = Details;
  buyer_count++;
  buyer_store[msg.sender] = buyer_count;
  seller_store[Details.SellerAdd] -= buyer_count;
}

   function getBalane() public view returns(uint) {
        return address(this).balance;
        // return participants[0].balance;

    }



}
