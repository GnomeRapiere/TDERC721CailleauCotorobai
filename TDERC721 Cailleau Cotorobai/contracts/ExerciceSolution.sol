pragma solidity ^0.6.0;
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
//raccourci pour commenter ctrl :

contract ExerciceSolution is ERC721
{
	
	uint256 private idanimal;
	mapping(uint256 => string) public namelist;
    mapping(uint256 => bool) public wingslist;
    mapping(uint256 => uint) public legslist;
    mapping(uint256 => uint) public sexlist;
	mapping(address => bool) public breederslist;
	mapping(uint => address) public idlist;
	mapping(uint => bool) public forsalelist;
	mapping(uint => uint) public priceslist;
	mapping(uint => uint) public fatherslist;
	mapping(uint => uint) public motherslist;
	mapping(uint => bool) public reproductionlist;
	mapping(uint => uint) public reproductionpriceslist;

	constructor(string memory name, string memory symbol) public ERC721(name, symbol) {
		idanimal = 1;
	}

	function sendToken(address a) external
	{
		_mint(a,idanimal);
	}

	function isBreeder(address account) external returns (bool)
	{
		return breederslist[account];
	}

	function registrationPrice() external returns (uint256)
	{
		return 1;
	}

	function registerBreeder(address a) external
	{
		breederslist[a] = true;
	}

	function registerMeAsBreeder() external payable
	{
		breederslist[msg.sender]=true;
	}
	
	function declareAnimal(uint sex, uint legs, bool wings, string calldata name) external returns (uint256)
    {
        idanimal = idanimal + 1;
        namelist[idanimal]=name;
        wingslist[idanimal]=wings;
        legslist[idanimal]=legs;
        sexlist[idanimal]=sex;
		idlist[idanimal]=msg.sender;
		//définir à l'origine le prix de l'animal à 0.
		//priceslist[idanimal]=0;
        _mint(msg.sender,idanimal);
        return idanimal;
    }

	

	function getAnimalCharacteristics(uint256 animalNumber) external returns (string memory _name, bool _wings, uint _legs, uint _sex)
	{
		return (namelist[animalNumber],wingslist[animalNumber],legslist[animalNumber],sexlist[animalNumber]);
	}

	function declareDeadAnimal(uint animalNumber) external
	{
		require(msg.sender == ownerOf(animalNumber));
		_burn(animalNumber);
		namelist[animalNumber] = "";
		wingslist[animalNumber] = false;
		legslist[animalNumber] = 0;
		sexlist[animalNumber] = 0;
		delete idlist[animalNumber];
		
	}

	

	function isAnimalForSale(uint animalNumber) external view returns (bool)
	{return forsalelist[animalNumber];}

	function animalPrice(uint animalNumber) external view returns (uint256)
	{return priceslist[animalNumber];}

	function offerForSale(uint animalNumber, uint price) external
	{
		forsalelist[animalNumber] = true;
		priceslist[animalNumber] = price;

	}

	function buyAnimal(uint animalNumber) external payable
	{
		//require(idlist[animalNumber] != msg.sender);
		require(forsalelist[animalNumber]);
		_transfer(ownerOf(animalNumber), msg.sender, animalNumber);
		(bool sent, bytes memory data) = ownerOf(animalNumber).call{value: msg.value}("");
        require(sent, "Failed to transfer Ether");
	}

	function declareAnimalWithParents(uint sex, uint legs, bool wings, string calldata name, uint parent1, uint parent2) external returns (uint256)
	{
		idanimal = idanimal + 1;
		fatherslist[idanimal] = parent1;
		motherslist[idanimal] = parent2;
        namelist[idanimal]=name;
        wingslist[idanimal]=wings;
        legslist[idanimal]=legs;
        sexlist[idanimal]=sex;
		idlist[idanimal]=msg.sender;
		_mint(msg.sender,idanimal);
		return idanimal;

	}

	function getParents(uint animalNumber) external returns (uint parent1,uint parent2)
	{
		return (fatherslist[animalNumber],motherslist[animalNumber]);
	}

	function canReproduce(uint animalNumber) external returns (bool)
	{
		return reproductionlist[animalNumber];
	}

	function reproductionPrice(uint animalNumber) external view returns (uint256)
	{
		return reproductionpriceslist[animalNumber];
	}

	function offerForReproduction(uint animalNumber, uint price) external returns (uint256)
	{
		require(msg.sender == ownerOf(animalNumber));
		reproductionlist[animalNumber] = true;
		reproductionpriceslist[animalNumber] = price;
		return animalNumber;
	}
	
}
