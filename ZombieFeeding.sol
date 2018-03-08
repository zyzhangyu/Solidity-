//在 Solidity 中，有两个地方可以存储变量 —— storage 或 memory。
//Storage 变量是指永久存储在区块链中的变量。
//Memory 变量则是临时的，当外部函数对某合约调用完成时，内存型变量即被移除。
//状态变量（在函数之外声明的变量）默认为“存储”形式，并永久写入区块链；
//而在函数内部声明的变量是“内存”型的，它们函数调用结束后消失。
//然而也有一些情况下，你需要手动声明存储类型，主要用于处理函数内的 结构体 和 数组 时

//除 public 和 private 属性之外，
//Solidity 还使用了另外两个描述函数可见性的修饰词：internal（内部） 和 external（外部）。
//internal 和 private 类似，
//不过， 如果某个合约继承自其父合约，这个合约即可以访问父合约中定义的“内部”函数。（嘿，这听起来正是我们想要的那样！）
//external 与public 类似，
//只不过这些函数只能在合约之外调用 - 它们不能被合约内的其他函数调用。稍后我们将讨论什么时候使用 external 和 public。

//如果我们的合约需要和区块链上的其他的合约会话，则需先定义一个 interface (接口)。
//接口的定义和合约类似，但是里面的函数不用写函数体的内容。

pragma solidity ^0.4.19;
import "./ZombieFactory.sol";


contract KittyInterface{
  function getKitty(uint256 _id) external view returns (
    bool isGestating,
    bool isReady,
    uint256 cooldownIndex,
    uint256 nextActionAt,
    uint256 siringWithId,
    uint256 birthTime,
    uint256 matronId,
    uint256 sireId,
    uint256 generation,
    uint256 genes
    );
}

contract ZombieFeeding is ZombieFactory {

    KittyInterface kittyContract ;

    function setKittyContractAddress(address _address) external onlyOwner{

      kittyContract = KittyInterface(_address);
    }

    function _triggerCooldown(Zombie _zombie) internal {

      _zombie.readyTime = uint32(now + cooldownTime);
    }

    function _isReady(Zombie storage _zombie) internal view returns(bool){
      return (_zombie.readyTime <= now)
    }

    function feedAndMultiply(uint _zombieId, uint _targetDna, string _species internal{



        require (zombieToOwner[_zombieId] == sender.msg);
        Zombie storage myZombie = zombies[_zombieId];
        require (_isReady(myZombie));
        _targetDna = _targetDna % dnaModulus;
        uint newDna = (myZombie.dna + _targetDna)/2;

        if (keccak256(_species) == keccak256("kitty")) {

          newDna = newDna - newDna % 100 + 99;
        }

        _createZombie("NoName",newDna);
        _triggerCooldown(myZombie);
    }

    function feedOnKitty(uint _zombieId,uint _kittyId) public {

      uint kittyDna;
      (,,,,,,,,,kittyDna) = kittyContract.getKitty(_kittyId);
      feedAndMultiply(_zombieId,kittyDna,"kitty");
    }
}
