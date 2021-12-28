pragma solidity ^0.4.17;
contract FakeNewsFactory{
    address[] public orgContracts;
    mapping(address=>bool) public approvers;
    uint approversCnt;
    mapping(address=>address) managerOrganizationMapper;
    mapping (address=> bool) checkManager;
    
    address[] public newsContracts;
    address[] public newsForApproval;
    
    
    function createOrg() public {
        
        require(checkManager[msg.sender] == false);
        checkManager[msg.sender]=true;
        address newOrg = new Organization(msg.sender);
        orgContracts.push(newOrg);
        if(approversCnt<=10){
            approversCnt++;
            approvers[newOrg]=true;
        }
        managerOrganizationMapper[msg.sender]=newOrg;
    }
    
    function getApproverCnt() public view returns(uint){
        return approversCnt;
    }
    
    function getOrganization() public view returns(address){
        return managerOrganizationMapper[msg.sender];
    }
    
    function getOrgBasedOnSender(address sender) public view returns(address){
        return managerOrganizationMapper[sender];
    }
    
    function getAllOrganizations() public view returns(address[]){
        return orgContracts;
    }
    
    function addToApprovers(address org) public{
        approvers[org] = true;
    }
    
    function removeFromApprovers(address org) public{
        approvers[org] = false;
    }
    
    function isApprover(address sender) public view returns(bool){
        return approvers[managerOrganizationMapper[sender]];
    }

    function updateApproversMapping(address approvalAddressTemp, bool value) public{
        approvers[approvalAddressTemp]=value;
        if(value==false){
            approversCnt--;
        }
        else{
            approversCnt++;
        }
    }

    function createNews(string t, string c, string sd, string ed) public {
        address orgAddress = managerOrganizationMapper[msg.sender];
        address newNews = new News(msg.sender, t, c, sd, ed,FakeNewsFactory(this) ,orgAddress);
        newsContracts.push(newNews);
        newsForApproval.push(newNews);
        Organization(orgAddress).addNewNews(newNews);
    }
    function getNewsForApproval() public view returns(address[]){
        return newsForApproval;
    }
    function getNewsForApprovalLength() public view returns(uint){
        return newsForApproval.length;
    }

    function getNewsForApprovalIndex(uint index) public view returns(address){
        return newsForApproval[index];
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
    address[] public positiveApprovers;
    address[] public negativeApprovers;
    uint public positiveApproversCnt;
    uint public negativeApproversCnt;
    mapping(address=>bool) public voted;
    string startDate;
    string endDate;
    string title;
    string content;
    
    FakeNewsFactory factory;
    Organization theOrganization;
    address organizationAddress;
    
    
    struct Info{
        bool isValid;
        bool stillOpen;
    }
    mapping(uint => Info) public inf;
    
    int threshold = 5;
    
    constructor(address creater, string t, string c, string sd, string ed, address factoryAddress, address orgAddress) public{
        manager = creater;
        title = t;
        content = c;
        startDate = sd;
        endDate = ed;
        factory = FakeNewsFactory(factoryAddress);
        theOrganization = Organization(orgAddress);
        organizationAddress = orgAddress;
        positiveApprovers.push(orgAddress);
        voted[orgAddress]=true;
        positiveApproversCnt+=1;
        
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
    
}