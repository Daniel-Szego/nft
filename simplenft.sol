pragma solidity ^0.6.6;

interface ERC721 {

    event Transfer(address indexed _from, address indexed _to, uint256 indexed _tokenId);

    event Approval(address indexed _owner, address indexed _approved, uint256 indexed _tokenId);

    event ApprovalForAll(address indexed _owner, address indexed _operator, bool _approved);

    function balanceOf(address _owner) external view returns (uint256);
 
    function ownerOf(uint256 _tokenId) external view returns (address);

    function safeTransferFrom(address _from, address _to, uint256 _tokenId, bytes memory data) external payable;

    function safeTransferFrom(address _from, address _to, uint256 _tokenId) external payable;

    function transferFrom(address _from, address _to, uint256 _tokenId) external payable;

    function approve(address _approved, uint256 _tokenId) external payable;

    function setApprovalForAll(address _operator, bool _approved) external;

    function getApproved(uint256 _tokenId) external view returns (address);

    function isApprovedForAll(address _owner, address _operator) external view returns (bool);
}

interface ERC721Metadata  {
    
    function name() external view returns (string memory _name);

    function symbol() external view returns (string memory _symbol);

    function tokenURI(uint256 _tokenId) external view returns (string memory);
    
}

contract MyNFT is ERC721, ERC721Metadata {

    // name of NFT
    string public override name;
    string public override symbol;
    string public uri;
    
    mapping (uint256 => address) public tokenIndexToOwner;
    mapping (address => uint256) ownershipTokenCount;
    uint maxSupply;
    
    constructor(string memory _name, string memory _symbol, string memory _uri) public {
        name = _name;
        symbol = _symbol;
        uri = _uri;
        
        // mint 1
        mint(msg.sender, 1);
        mint(msg.sender, 2);
        mint(msg.sender, 3);
        
    }

    function mint(address _to, uint256 _tokenId) public {
        require(tokenIndexToOwner[_tokenId] == address(0));
        tokenIndexToOwner[_tokenId] = _to;
        ownershipTokenCount[_to] += 1;
        maxSupply += 1;
    }

    function tokenURI(uint256 _tokenId) external view override returns (string memory) {
        return uri;
    }

    // how many nft has the owner    
    function balanceOf(address _owner) public view override returns (uint256 balance) {
        return ownershipTokenCount[_owner];
    }

    // who is the owner of the token
    function ownerOf(uint256 _tokenId) external view override returns (address owner) {
        return tokenIndexToOwner[_tokenId];        
    }

    function transferFrom(address _from, address _to, uint256 _tokenId) external payable override {
        require(msg.sender == _from, "from must be sender");        
        require(tokenIndexToOwner[_tokenId] == _from, "from must have the token");
        tokenIndexToOwner[_tokenId] = _to;
        ownershipTokenCount[msg.sender] -= 1;
        ownershipTokenCount[_to] += 1;

        emit Transfer(_from, _to, _tokenId);
    }

    function safeTransferFrom(address _from, address _to, uint256 _tokenId, bytes memory data) external payable override {}

    function safeTransferFrom(address _from, address _to, uint256 _tokenId) external payable override {}

    function approve(address _approved, uint256 _tokenId) external payable override {}

    function setApprovalForAll(address _operator, bool _approved) external override {}

    function getApproved(uint256 _tokenId) external view override returns (address) {}

    function isApprovedForAll(address _owner, address _operator) external view override returns (bool) {}

}