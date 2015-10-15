contract DigixbotConfiguration {
  function DigixbotConfiguration();
  function lockConfiguration();
  function getBotContract() returns(address );
  function getCoinWallet(bytes4 _coin) constant returns(address );
  function addCoin(bytes4 _name,address _wallet);
  function getOwner() constant returns(address );
  function setUsersContract(address _userscontract);
  function getUsersContract() returns(address );
  function setBotContract(address _botcontract);
}

contract Coin {
  function getBotContract() returns(address );
  function getUserId(address _address) returns(bytes32 );
  function withdrawCoin(bytes32 _user,uint256 _amount);
  function depositCoin(bytes32 _uid,uint256 _amt);
  function getBalance(bytes32 _uid) returns(uint256 );
  function totalBalance() returns(uint256 );
  function getConfig() returns(address );
  function getUsersContract() returns(address );
  function sendCoin(bytes32 _sender,bytes32 _recipient,uint256 _amt);
}

contract DigixbotUsers {
  function getBotContract() returns(address );
  function setUserAccount(bytes32 _id,address _account);
  function getUserId(address _account) returns(bytes32 );
  function getUserAccount(bytes32 _id) returns(address );
  function getOwner() returns(address );
  function addUser(bytes32 _id);
  function getConfig() returns(address );
  function userCheck(bytes32 _id) returns(bool );
}


contract Digixbot {
  address owner;
  address config;

  function Digixbot(address _config) {
    owner = msg.sender;
    config = _config;
  }

  modifier ifowner { if(msg.sender == owner) _ }

  function getConfig() public returns (address) {
    return config;
  }

  function addUser(bytes32 _userid) ifowner {
    DigixbotUsers(getUsersContract()).addUser(_userid); 
  }

  function setUserAccount(bytes32 _userid, address _account) ifowner {
    DigixbotUsers(getUsersContract()).setUserAccount(_userid, _account);
  }

  function getUsersContract() public returns (address) {
    return DigixbotConfiguration(config).getUsersContract();
  }

  function getCoinWallet(bytes4 _coin) public returns(address) {
    return DigixbotConfiguration(config).getCoinWallet(_coin);
  }

  function userCheck(bytes32 _id) public returns(bool) {
    return DigixbotUsers(getUsersContract()).userCheck(_id);
  }

  function sendCoin(bytes4 _coin, bytes32 _from, bytes32 _to, uint _amount) ifowner {
    Coin(getCoinWallet(_coin)).sendCoin(_from, _to, _amount); 
  }
    
  function withdrawCoin(bytes4 _coin, bytes32 _userid, uint _amount) ifowner {
    Coin(getCoinWallet(_coin)).withdrawCoin(_userid, _amount);
  }

  function getCoinBalance(bytes4 _coin, bytes32 _userid) public returns(uint) {
    return Coin(getCoinWallet(_coin)).getBalance(_userid);
  }

  function getTotalBalance(bytes4 _coin) public returns(uint) {
    return Coin(getCoinWallet(_coin)).totalBalance();
  }

}
