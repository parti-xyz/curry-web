class Special
  SLUG_VOTEAWARD2018 = 'voteaward2018'

  def self.build_campaign(campaign)
    if campaign.special_slug == Special::SLUG_VOTEAWARD2018
      campaign.goal_count = 0
    end
    campaign.action_targets.build(action_assignable: Election.of_slug(Election::SLUG_20180613))
  end

  def self.decorate_agent_organization(specialable, agent)
    if specialable.respond_to?(:special_slug) and specialable.special_slug == Special::SLUG_VOTEAWARD2018
      election_candidate = Election.of_slug(Election::SLUG_20180613).election_candidates.find_by(agent_id: agent.id)
      if election_candidate.present?
        return "#{election_candidate.election_category}\n#{election_candidate.area_division}"
      end
    end

    agent.organization
  end
end
