pragma solidity^0.4.11;
contract Conference{
  address public organizer;
  mapping (address=>uint) public registrantsPaid;
  uint public numRegistrants;
  uint public quota;

  // so we can log these events
  event Deposit(address _from,uint _amount);
  event Refund(address _to,uint _amount);

  function Conference(){
    // Constructor function
    organizer=msg.sender;
    quota=500;
    numRegistrants=0;
  }
  function buyTicker() public returns (bool success){
    if(numRegistrants>=quota) { return false;}
    registrantsPaid[msg.sender]=msg.value;
    numRegistrants++;
    Deposit(msg.sender,msg.value);
    return true;
  }
  function changeQuota(uint newquota) public{
    if(msg.sender!=organizer) {return;}
    quota=newquota;
  }
  function refundTicket(address recipient, uint amount) public{
    if(msg.sender!=organizer) {return;}
    if(registrantsPaid[recipient]==amount){
      address myAddress=this;
      if(myAddress.balance>=amount){
        recipient.send(amount);
        registrantsPaid[recipient]=0;
        numRegistrants--;
        Refund(recipient,amount);
      }
    }
  }
  function destroy(){
    // so that funds dont get stuck in contract forever
    if(msg.sender==organizer){
      suicide(organizer); //send funds to organizer
    }
  }
}
