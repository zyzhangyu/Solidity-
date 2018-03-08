//在数组后面加上 memory关键字， 表明这个数组是仅仅在内存中创建，不需要写入外部存储，并且在函数调用结束时它就解散了。
//与在程序结束时把数据保存进 storage 的做法相比，内存运算可以大大节省gas开销 -- 把这数组放在view里用，完全不用花钱。

pragma solidity ^0.4.19;
import "./ZombieFeeding";

contract ZombieHelper is ZombieFeeding {

    modifier aboveLevel(uint _level, uint _zombieId) {
        require (zombies[_zombieId].level >= _level);
        _;
    }

    function changeName(uint _zombieId, string _newName) external aboveLevel(2, _zombieId){
        require(msg.sender ==zombieToOwner[_zombieId]);
        zombies[_zombieId].name = _newName;

    }
    function changeDna(uint _zombieId, uint _newDna) external aboveLevel(20, _zombieId) {
        require(msg.sender == zombieToOwner[_zombieId]);
        zombies[_zombieId].dna = _newDna;
    }

    function getZombiesByOwner (address _owner) external view returns(uint[]){

        uint zombieCount = ownerZombieCount(_owner);
        uint[] memory result = new uint[](zombieCount);

        uint counter = 0;
        for (uint i = 0; i <zombies.length; i++){
           if (zombieToOwner[i] == _owner){
             result[counter] = i;
             counter++;
           }
        }
        return result;
    }
}
