pragma solidity ^0.4.17;

// import "hardhat/console.sol";

contract FakeNewsFactory{

    mapping(address=>address) public managerOrganizationMapper;
    mapping (address=> bool) public checkManager;
    uint moneyToBeSentToPublishNews = 100;
    uint thisMonthBalance = 0;
    
    function createOrg() public returns(address) {  
        address sender = msg.sender;      
        require(checkManager[sender] == false);        
        checkManager[sender]=true;
        address newOrg = new Organization(sender);
        managerOrganizationMapper[sender]=newOrg;
        return newOrg;
    }    
    
    function getOrganization() public view returns(address){
        return managerOrganizationMapper[msg.sender];
    }
    
    function getOrgBasedOnSender(address sender) public view returns(address){
        return managerOrganizationMapper[sender];
    }

    function createNews(string t, string c, string sd, string ed) public payable{
        require(msg.value>=moneyToBeSentToPublishNews);
        thisMonthBalance+=msg.value;
        address sender = msg.sender;
        address orgAddress = managerOrganizationMapper[sender];
        address newNews = new News(sender, t, c, sd, ed, orgAddress);
        
        Organization temp = Organization(orgAddress);
        temp.addNewNews(newNews);
    }

    function getBalance() public view returns(uint){
        return thisMonthBalance;
    }

    function getContractBalance() public view returns(uint){
        return address(this).balance;
    }
    function sendMoneyToWinner(address add) public {
        uint half = (thisMonthBalance)/2;
        // console.log(half);
        add.transfer(half);
        thisMonthBalance=0;
    }
}

contract Organization{
    int public reputationScore=5;
    address public manager;
    string orgName;
    string orgDescription;
    address[] public newspublished;

    
    constructor(address creater) public{
        manager = creater;
    }
    function newspublishedArray() public view returns(address[]){
        return newspublished;
    }
    function modifyReputationScore(int value) public{
        reputationScore=reputationScore+value;
    }
    
    function getReputationScore() public view returns(int){
        return reputationScore;
    }
    
    function addNewNews(address news) public{
        newspublished.push(news);
    }

    function updateOrgDetails(string name, string description) public {
        orgName = name;
        orgDescription = description;
    }
}

contract News{
    address public manager;
    uint public positiveApproversCnt;
    uint public negativeApproversCnt;
    mapping(address=>bool) public voted;
    string public startDate;
    string public endDate;
    string public title;
    string public content;
    
    FakeNewsFactory factory;
    Organization organizationContract;
    address organizationAddress;
    
    
    struct Info{
        bool isValid;
        bool stillOpen;
    }
    mapping(uint => Info) public inf;
    
    int threshold = 5;
    
    constructor(address creater, string t, string c, string sd, string ed, address orgAddress) public{
        manager = creater;
        title = t;
        content = c;
        startDate = sd;
        endDate = ed;
        organizationContract = Organization(orgAddress);
        organizationAddress = orgAddress;
        positiveApproversCnt=0;
        negativeApproversCnt=0;
        
        Info storage f = inf[1];
        f.isValid=false;
        f.stillOpen = true;
    }
    
    function getSummary() public view returns ( string, string, bool, string, bool){
        return(
            title,
            content,
            inf[1].isValid,
            startDate,
            inf[1].stillOpen
        );
    }

    function getEndDate() public view returns(string){
        return endDate;
    }

    function vote(bool approve) public{
        require(voted[msg.sender]==false);
        voted[msg.sender]=true;
        if(approve){
            positiveApproversCnt+=1;
        }else{
            negativeApproversCnt-=1;
        }
    }
    
}