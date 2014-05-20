module OnboardDataUploadx
  require 'workflow'
  class EngineInit < ActiveRecord::Base
    include Workflow
    workflow_column :wf_state
    
    workflow do
      wf = Authentify::AuthentifyUtility.find_config_const('engine_init_wf_pdef', 'onboard_data_uploadx')
      if Authentify::AuthentifyUtility.find_config_const('wf_pdef_in_config') == 'true' && wf.present?
        eval(wf) 
      elsif Rails.env.test?  
        state :initial_state do
          event :submit, :transitions_to => :reviewing
        end
        state :reviewing do
          event :review_reject, :transitions_to => :initial_state
          event :review_pass, :transitions_to => :testing 
        end
        state :testing do
          event :test_reject, :transitions_to => :initial_state
          event :test_pass, :transitions_to => :commissioning
        end
        state :commissioning do
          event :commission, :transitions_to => :commissioned
        end
        state :commissioned do
          event :rewind, :transitions_to => :initial_state  #be careful with this rewind if there is active deployment
          event :decommissioned, :transitions_to => :decommissioned
        end
        state :decommissioned
        
        
      end
    end
    attr_accessor  :wf_comment, :id_noupdate, :wf_state_noupdate, :wf_event, :last_updated_by_name, :engine_id_noupdate, :engine_name
    attr_accessible :engine_id, :file_name, :init_code, :init_desp, :wf_state, 
                    :as => :role_new
    attr_accessible :commissioned, :commissioned_by_id, :commissioned_date, :decommissioned, :decommissioned_by_id, :decommissioned_date, :engine_id, :file_name, 
                    :init_code, :init_desp, :reviewed, :reviewed_by_id, :reviewed_date, :tested, :tested_by_id, :tested_date, :wf_state,
                    :wf_comment, :id_noupdate, :wf_state_noupdate, :engine_id, :engine_name, 
                    :as => :role_update
    
    attr_accessor :start_date_s, :end_date_s, :submitted_by_id_s, :commissioned_s, :decommissioned_s, :tested_s, :reviewed_s, :file_name_s, :engine_name_s, 
                  :init_desp_s, :commissioned_by_id_s, :decommissioned_by_id_s, :tested_by_id_s, :reviewed_by_id_s

    attr_accessible :start_date_s, :end_date_s, :submitted_by_id_s, :commissioned_s, :decommissioned_s, :tested_s, :reviewed_s, :file_name_s, :engine_name_s, 
                    :init_desp_s, :commissioned_by_id_s, :decommissioned_by_id_s, :tested_by_id_s, :reviewed_by_id_s,
                    :as => :role_search_stats
    
    belongs_to :last_updated_by, :class_name => 'Authentify::User'
    belongs_to :submitted_by, :class_name => 'Authentify::User'
    belongs_to :commissioned_by, :class_name => 'Authentify::User'
    belongs_to :decommissioned_by, :class_name => 'Authentify::User' 
    belongs_to :reviewed_by, :class_name => 'Authentify::User'
    belongs_to :tested_by, :class_name => 'Authentify::User' 
    belongs_to :engine, :class_name => OnboardDataUploadx.engine_class.to_s
    
    validates :init_desp, :init_code, :file_name, :presence => true 
    validates :engine_id, :presence => true, :numericality => {:only_integer => true, :greater_than => 0}
    validates :init_desp, :uniqueness => {:scope => :engine_id, :case_sensitive => false, :message => I18n.t('Duplicate Description')} 
    validate :dynamic_validate 
    
    def dynamic_validate
      wf = Authentify::AuthentifyUtility.find_config_const('dynamic_validate_engine_init', 'onboard_data_uploadx')
      eval(wf) if wf.present?
    end        
                                          
    #for workflow input validation  
    validate :validate_wf_input_data, :if => 'wf_state.present?' 
    
    def validate_wf_input_data
      wf = Authentify::AuthentifyUtility.find_config_const('validate_engine_init_' + self.wf_event, 'onboard_data_uploadx') if self.wf_event.present?
      if Authentify::AuthentifyUtility.find_config_const('wf_validate_in_config') == 'true' && wf.present? 
        eval(wf) 
      end
    end         
  end
end
