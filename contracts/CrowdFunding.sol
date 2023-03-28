// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;

contract CrowdFunding {
    struct Campaign {
        address owner;
        string title;
        string description;
        uint256 target;
        uint256 deadline;
        uint256 amountCollected;
        string image;
        address[] donators;
        uint256[] donatorAmounts;
    }

    mapping(uint256 => Campaign) public campaigns;
    //maping helps to access the campaign like Campaign[0]. In javascript we can access it like campaigns[0] but in solidity we can't do that. So we use mapping to access the campaign.

    uint256 public numberofCampaigns = 0;

    //owner of the contract _owner is a parameter only for this function 

    function createCampaign(
        address _owner, 
        string memory _title, 
        string memory _description, 
        uint256 _target, 
        uint256 _deadline, 
        string memory _image 
        )  public returns(uint256) {

        Campaign storage campaign = campaigns[numberofCampaigns];

        require (campaign.deadline < block.timestamp, "The deadline should a date in the future.");

        campaign.owner = _owner;
        campaign.title = _title;
        campaign.description = _description;
        campaign.target = _target;
        campaign.deadline = _deadline;
        campaign.amountCollected = 0;
        campaign.image = _image;

        numberofCampaigns++;
        
        return numberofCampaigns - 1;
    }

    function donateToCampaign( uint256 _campaignId)  public payable {
        uint256 amount = msg.value; //msg.value passed in argument will get the amount value

        Campaign storage campaign = campaigns[_campaignId];

        campaign.donators.push(msg.sender);
        campaign.donatorAmounts.push(amount);

        (bool sent, ) = payable(campaign.owner).call{value: amount}("");

        if (sent) {
            campaign.amountCollected += amount;
        }
    }

    function getDonators(uint256 _campaignId)  public view returns(address[] memory, uint256[] memory) {
        // Campaign storage campaign = campaigns[_campaignId];

        return (campaigns[_campaignId].donators, campaigns[_campaignId].donatorAmounts);
    }

    function getCampaigns() public view returns (Campaign[] memory) {
        // creatiing arrary of campaigns [ {}, {}, {}]
        Campaign[] memory allCampaigns = new Campaign[](numberofCampaigns);

        for (uint256 i = 0; i < numberofCampaigns; i++) {
            allCampaigns[i] = campaigns[i];
        }

        return allCampaigns; 
    }   
}