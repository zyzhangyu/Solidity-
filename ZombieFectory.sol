

//private这意味着只有我们合约中的其它函数才能够调用这个函数
//view意味着它只能读取数据不能更改数据,即，它没有改变任何值或者写任何东西
// pure 函数, 表明这个函数甚至都不访问应用里的数据,它的返回值完全取决于它的输入参数，在这种情况下我们把函数定义为 pure.
//散列函数keccak256,它用了SHA3版本。一个散列函数基本上就是把一个字符串转换为一个256位的16进制数字。字符串的一个微小变化会引起散列数据极大变化。
//array.push() 返回数组的长度类型是uint
//msg.sender 在 Solidity 中，有一些全局变量可以被所有函数调用。 其中一个就是 msg.sender，它指的是当前调用者（或智能合约）的 address
//在 Solidity 中，功能执行始终需要从外部调用者开始。 一个合约只会在区块链上什么也不做，除非有人调用其中的函数。所以 msg.sender总是存在的。
//require require使得函数在执行过程中，当不满足某些条件时抛出错误，并停止执行
//inheritance (继承)
pragma solidity ^0.4.19;
import "./Ownable.sol";

contract ZombieFactory is Ownable {

  event NewZombie(uint zombieId, string name, uint dna);

	uint dnaDigits = 16;
  uint dnaModulus = 10 ** dnaDigits;
  uint cooldownTime = 1 days;

  struct Zombie {

  	string name;
  	uint dna;
    uint32 level;
    uint32 readyTime;
  }

  Zombie[] public zombies;
  mapping (uint => address) public zombieToOwner;
  mapping (address => uint) ownerZombieCount;


  function createRandomZombie(string _name) public returns(uint){

    require (ownerZombieCount[msg.sender]) == 0;
    uint randDna = _generateRandomDna(_name);
    _createZombie(_name,randDna);
  }

  function _createZombie(string _name, uint _dna) internal{
    uint32 tempTime = uint32(now + cooldownTime);
    Zombie zombie = Zombie(_name,_dna,1, tempTime);
    zombies.push(zombie);

    uint id = zombies.push() - 1;
    zombieToOwner(id) = sender.msg;
    ownerZombieCount(sender.msg)++;
    NewZombie(id, _name, _dna);
  }

  function _generateRandomDna(string _str) private view returns(uint){
    uint rand = uint(keccak256(_str));
    return rand % dnaModulus;
  }
}
