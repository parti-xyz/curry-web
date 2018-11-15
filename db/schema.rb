# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20181106153306) do

  create_table "action_targets", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC" do |t|
    t.string  "action_assignable_id",   null: false
    t.string  "action_assignable_type", null: false
    t.string  "action_targetable_type"
    t.integer "action_targetable_id"
    t.index ["action_assignable_id", "action_assignable_type", "action_targetable_type", "action_targetable_id"], name: "action_target_unique", unique: true, using: :btree
  end

  create_table "agencies", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC" do |t|
    t.string   "title",      null: false
    t.string   "slug",       null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string   "image"
  end

  create_table "agencies_positions", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC" do |t|
    t.integer "agency_id",   null: false
    t.integer "position_id", null: false
    t.index ["agency_id", "position_id"], name: "index_agencies_positions_on_agency_id_and_position_id", unique: true, using: :btree
    t.index ["agency_id"], name: "index_agencies_positions_on_agency_id", using: :btree
    t.index ["position_id"], name: "index_agencies_positions_on_position_id", using: :btree
  end

  create_table "agenda_documents", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC" do |t|
    t.integer  "agent_id",                 null: false
    t.integer  "agenda_id",                null: false
    t.integer  "user_id"
    t.string   "attachment",               null: false
    t.string   "name"
    t.string   "file_type"
    t.string   "file_size"
    t.text     "desc",       limit: 65535
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
    t.index ["agenda_id"], name: "index_agenda_documents_on_agenda_id", using: :btree
    t.index ["agent_id"], name: "index_agenda_documents_on_agent_id", using: :btree
    t.index ["user_id"], name: "index_agenda_documents_on_user_id", using: :btree
  end

  create_table "agenda_themes", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC" do |t|
    t.string   "title",                    null: false
    t.text     "body",       limit: 65535
    t.string   "slug",                     null: false
    t.integer  "project_id"
    t.string   "cover"
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
    t.index ["project_id"], name: "index_agenda_themes_on_project_id", using: :btree
    t.index ["slug"], name: "index_agenda_themes_on_slug", using: :btree
  end

  create_table "agenda_themes_agendas", id: false, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC" do |t|
    t.integer "agenda_theme_id"
    t.integer "agenda_id"
    t.index ["agenda_theme_id", "agenda_id"], name: "index_agenda_themes_agendas_on_agenda_theme_id_and_agenda_id", unique: true, using: :btree
  end

  create_table "agendas", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC" do |t|
    t.integer  "user_id"
    t.text     "memo",                      limit: 65535
    t.string   "image"
    t.integer  "comments_count",                          default: 0
    t.integer  "likes_count",                             default: 0
    t.datetime "created_at",                                          null: false
    t.datetime "updated_at",                                          null: false
    t.integer  "anonymous_likes_count",                   default: 0
    t.string   "name"
    t.text     "request_amendment_example", limit: 65535
    t.text     "request_opinion_example",   limit: 65535
    t.index ["user_id"], name: "index_agendas_on_user_id", using: :btree
  end

  create_table "agendas_issues", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC" do |t|
    t.integer "agenda_id"
    t.integer "issue_id"
    t.index ["agenda_id"], name: "index_agendas_issues_on_agenda_id", using: :btree
    t.index ["issue_id"], name: "index_agendas_issues_on_issue_id", using: :btree
  end

  create_table "agents", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC" do |t|
    t.string   "name",                                null: false
    t.string   "organization"
    t.string   "category",                            null: false
    t.string   "image"
    t.string   "email"
    t.integer  "sent_requests_count",     default: 0
    t.string   "twitter"
    t.string   "public_site"
    t.string   "election_region"
    t.string   "access_token"
    t.integer  "access_fail_count",       default: 0
    t.string   "refresh_access_token"
    t.datetime "refresh_access_token_at"
  end

  create_table "agents_campaigns", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC" do |t|
    t.integer  "campaign_id"
    t.integer  "agent_id"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.index ["agent_id"], name: "index_agents_campaigns_on_agent_id", using: :btree
    t.index ["campaign_id", "agent_id"], name: "index_agents_campaigns_on_campaign_id_and_agent_id", unique: true, using: :btree
    t.index ["campaign_id"], name: "index_agents_campaigns_on_campaign_id", using: :btree
  end

  create_table "appointments", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC" do |t|
    t.integer  "position_id", null: false
    t.integer  "agent_id",    null: false
    t.date     "started_at"
    t.date     "ended_at"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.index ["agent_id"], name: "index_appointments_on_agent_id", using: :btree
    t.index ["position_id"], name: "index_appointments_on_position_id", using: :btree
  end

  create_table "archive_categories", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC" do |t|
    t.integer  "archive_id",               null: false
    t.integer  "parent_id"
    t.string   "slug",                     null: false
    t.string   "name",                     null: false
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
    t.text     "desc",       limit: 65535
    t.index ["archive_id", "slug"], name: "index_archive_categories_on_archive_id_and_slug", unique: true, using: :btree
    t.index ["archive_id"], name: "index_archive_categories_on_archive_id", using: :btree
    t.index ["parent_id"], name: "index_archive_categories_on_parent_id", using: :btree
    t.index ["slug"], name: "index_archive_categories_on_slug", using: :btree
  end

  create_table "archive_documents", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC" do |t|
    t.string   "title",                                          null: false
    t.text     "body",                 limit: 65535
    t.integer  "user_id",                                        null: false
    t.integer  "archive_id",                                     null: false
    t.integer  "comments_count",                     default: 0
    t.integer  "likes_count",                        default: 0
    t.string   "content_creator"
    t.string   "content_created_time"
    t.string   "content_source"
    t.string   "content"
    t.string   "content_name"
    t.string   "content_type"
    t.integer  "content_size"
    t.datetime "created_at",                                     null: false
    t.datetime "updated_at",                                     null: false
    t.string   "category_slug"
    t.string   "media_type"
    t.string   "content_created_date"
    t.string   "content_recipients"
    t.string   "donor"
    t.boolean  "is_secret_donor"
    t.index ["archive_id"], name: "index_archive_documents_on_archive_id", using: :btree
    t.index ["user_id"], name: "index_archive_documents_on_user_id", using: :btree
  end

  create_table "archive_sewol_inv_documents", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC" do |t|
    t.integer "archive_document_id"
    t.string  "part_no"
    t.string  "part_name"
    t.string  "code"
    t.string  "doc_no"
    t.string  "report_date"
    t.string  "doc_type"
    t.string  "title"
    t.string  "recipients"
    t.string  "reporter"
    t.string  "reviewer"
    t.string  "has_attachment"
    t.string  "status"
    t.string  "doc_kind"
    t.string  "open_type"
    t.text    "open_level_desc",        limit: 65535
    t.string  "open_retype"
    t.text    "open_relevel_desc",      limit: 65535
    t.string  "partial_open_redaction"
    t.string  "prod_code_no"
    t.string  "task_card_name"
    t.string  "task_name"
    t.string  "task_storaging_period"
    t.index ["archive_document_id"], name: "index_archive_sewol_inv_documents_on_archive_document_id", using: :btree
  end

  create_table "archives", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC" do |t|
    t.string   "title",                                     null: false
    t.text     "body",            limit: 65535
    t.string   "cover_image"
    t.string   "social_image"
    t.integer  "user_id",                                   null: false
    t.integer  "comments_count",                default: 0
    t.integer  "likes_count",                   default: 0
    t.datetime "created_at",                                null: false
    t.datetime "updated_at",                                null: false
    t.string   "slug"
    t.integer  "organization_id"
    t.index ["organization_id"], name: "index_archives_on_organization_id", using: :btree
    t.index ["user_id"], name: "index_archives_on_user_id", using: :btree
  end

  create_table "areas", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC" do |t|
    t.string   "code",         null: false
    t.string   "division",     null: false
    t.string   "subdivision"
    t.string   "neighborhood"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
    t.index ["code"], name: "index_areas_on_code", using: :btree
  end

  create_table "articles", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC" do |t|
    t.text     "url",                   limit: 65535
    t.text     "body",                  limit: 65535
    t.string   "title"
    t.text     "desc",                  limit: 65535
    t.text     "metadata",              limit: 65535
    t.string   "image"
    t.string   "page_type"
    t.string   "crawling_status"
    t.datetime "crawled_at"
    t.string   "site_name"
    t.integer  "image_height",                        default: 0
    t.integer  "image_width",                         default: 0
    t.integer  "user_id"
    t.integer  "likes_count",                         default: 0
    t.integer  "comments_count",                      default: 0
    t.integer  "anonymous_likes_count",               default: 0
    t.datetime "created_at",                                      null: false
    t.datetime "updated_at",                                      null: false
    t.integer  "hot_score",                           default: 0
    t.string   "hot_scored_datestamp"
    t.index ["user_id"], name: "index_articles_on_user_id", using: :btree
  end

  create_table "assembly_members", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC" do |t|
    t.string  "deptCd"
    t.string  "num"
    t.string  "assemEmail"
    t.string  "assemHomep"
    t.string  "assemTel"
    t.string  "bthDate"
    t.string  "electionNum"
    t.string  "empNm"
    t.string  "engNm"
    t.text    "examCd",      limit: 65535
    t.text    "hbbyCd",      limit: 65535
    t.string  "hjNm"
    t.text    "memTitle",    limit: 65535
    t.string  "origNm"
    t.string  "polyNm"
    t.string  "reeleGbnNm"
    t.text    "secretary",   limit: 65535
    t.text    "secretary2",  limit: 65535
    t.string  "shrtNm"
    t.string  "staff"
    t.string  "jpgLink"
    t.integer "agent_id"
    t.index ["agent_id"], name: "index_assembly_members_on_agent_id", using: :btree
  end

  create_table "bulk_tasks", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC" do |t|
    t.string   "job_id"
    t.text     "desc",                 limit: 65535
    t.integer  "user_id",                                           null: false
    t.integer  "archive_id",                                        null: false
    t.string   "attachment"
    t.string   "attachment_name"
    t.string   "status",                             default: "등록", null: false
    t.integer  "processing_count",                   default: 0
    t.integer  "success_count",                      default: 0
    t.integer  "error_count",                        default: 0
    t.integer  "inserted_count",                     default: 0
    t.integer  "updated_count",                      default: 0
    t.text     "error_detail",         limit: 65535
    t.datetime "created_at",                                        null: false
    t.datetime "updated_at",                                        null: false
    t.string   "google_access_token"
    t.string   "google_refresh_token"
    t.index ["archive_id"], name: "index_bulk_tasks_on_archive_id", using: :btree
    t.index ["job_id"], name: "index_bulk_tasks_on_job_id", using: :btree
    t.index ["user_id"], name: "index_bulk_tasks_on_user_id", using: :btree
  end

  create_table "campaigns", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC" do |t|
    t.string   "title"
    t.text     "body",                         limit: 65535
    t.integer  "project_id"
    t.integer  "user_id"
    t.datetime "created_at",                                                      null: false
    t.datetime "updated_at",                                                      null: false
    t.integer  "likes_count",                                default: 0
    t.integer  "signs_goal_count",                           default: 1000
    t.integer  "signs_count",                                default: 0
    t.integer  "views_count",                                default: 0
    t.string   "cover_image"
    t.integer  "anonymous_likes_count",                      default: 0
    t.text     "thanks_mention",               limit: 65535
    t.boolean  "comment_enabled",                            default: true
    t.string   "sign_title"
    t.string   "social_image"
    t.boolean  "use_signer_real_name",                       default: false
    t.boolean  "use_signer_email",                           default: false
    t.boolean  "use_signer_address",                         default: false
    t.string   "signer_real_name_title"
    t.string   "signer_email_title"
    t.string   "signer_address_title"
    t.text     "confirm_privacy",              limit: 65535
    t.string   "agent_section_title"
    t.string   "agent_section_response_title"
    t.boolean  "use_signer_phone",                           default: false
    t.string   "signer_phone_title"
    t.boolean  "sign_hidden",                                default: false,      null: false
    t.integer  "area_id"
    t.string   "special_slug"
    t.integer  "issue_id"
    t.datetime "closed_at"
    t.string   "sign_form_intro"
    t.string   "slug"
    t.integer  "comments_count",                             default: 0
    t.string   "template",                                   default: "petition"
    t.string   "title_to_agent"
    t.text     "message_to_agent",             limit: 65535
    t.integer  "previous_event_id"
    t.text     "css",                          limit: 65535
    t.index ["area_id"], name: "index_campaigns_on_area_id", using: :btree
    t.index ["issue_id"], name: "index_campaigns_on_issue_id", using: :btree
    t.index ["project_id"], name: "index_campaigns_on_project_id", using: :btree
    t.index ["user_id"], name: "index_campaigns_on_user_id", using: :btree
  end

  create_table "citizen2017_speeches", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC" do |t|
    t.string  "title"
    t.integer "citizen2017_id"
    t.string  "video_url"
    t.integer "speech_id"
    t.index ["speech_id"], name: "index_citizen2017_speeches_on_speech_id", using: :btree
  end

  create_table "clypits", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC" do |t|
    t.integer  "archive_document_id", null: false
    t.string   "audio_file_id"
    t.datetime "created_at",          null: false
    t.datetime "updated_at",          null: false
    t.index ["archive_document_id"], name: "index_clypits_on_archive_document_id", using: :btree
    t.index ["audio_file_id"], name: "index_clypits_on_audio_file_id", using: :btree
  end

  create_table "comments", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC" do |t|
    t.integer  "user_id"
    t.string   "commentable_type"
    t.integer  "commentable_id",                                      null: false
    t.text     "body",                  limit: 65535
    t.datetime "created_at",                                          null: false
    t.datetime "updated_at",                                          null: false
    t.string   "choice"
    t.string   "commenter_name"
    t.string   "commenter_email"
    t.integer  "reports_count",                       default: 0
    t.integer  "likes_count",                         default: 0
    t.string   "image"
    t.float    "latitude",              limit: 24
    t.float    "longitude",             limit: 24
    t.string   "full_street_address"
    t.integer  "anonymous_likes_count",               default: 0
    t.boolean  "toxic",                               default: false
    t.integer  "target_agent_id"
    t.string   "mailing",                                             null: false
    t.index ["commentable_type", "commentable_id"], name: "index_comments_on_commentable_type_and_commentable_id", using: :btree
    t.index ["target_agent_id"], name: "index_comments_on_target_agent_id", using: :btree
    t.index ["user_id"], name: "index_comments_on_user_id", using: :btree
  end

  create_table "deprecated_agents_events", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC" do |t|
    t.integer  "deprecated_event_id"
    t.integer  "agent_id"
    t.datetime "created_at",          null: false
    t.datetime "updated_at",          null: false
    t.index ["agent_id"], name: "index_deprecated_agents_events_on_agent_id", using: :btree
  end

  create_table "deprecated_candidates", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC" do |t|
    t.string   "name"
    t.text     "body",        limit: 65535
    t.string   "image"
    t.integer  "election_id",               null: false
    t.integer  "user_id",                   null: false
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
    t.index ["election_id"], name: "index_deprecated_candidates_on_election_id", using: :btree
    t.index ["user_id"], name: "index_deprecated_candidates_on_user_id", using: :btree
  end

  create_table "deprecated_elections", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC" do |t|
    t.string   "title"
    t.text     "body",            limit: 65535
    t.string   "image"
    t.integer  "user_id",                       null: false
    t.integer  "project_id"
    t.datetime "registered_from",               null: false
    t.datetime "registered_to",                 null: false
    t.datetime "voted_from",                    null: false
    t.datetime "voted_to",                      null: false
    t.datetime "created_at",                    null: false
    t.datetime "updated_at",                    null: false
    t.index ["project_id"], name: "index_deprecated_elections_on_project_id", using: :btree
    t.index ["user_id"], name: "index_deprecated_elections_on_user_id", using: :btree
  end

  create_table "deprecated_events", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC" do |t|
    t.string   "slug"
    t.string   "title"
    t.text     "body",             limit: 65535
    t.string   "image"
    t.integer  "user_id"
    t.integer  "comments_count",                 default: 0
    t.datetime "created_at",                                 null: false
    t.datetime "updated_at",                                 null: false
    t.integer  "project_id"
    t.string   "template"
    t.text     "css",              limit: 65535
    t.string   "social_image"
    t.string   "title_to_agent"
    t.text     "message_to_agent", limit: 65535
    t.datetime "closed_at"
    t.index ["project_id"], name: "index_deprecated_events_on_project_id", using: :btree
    t.index ["user_id"], name: "index_deprecated_events_on_user_id", using: :btree
  end

  create_table "deprecated_sns_events", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC" do |t|
    t.string   "facebook_hashtags"
    t.string   "facebook_href"
    t.text     "tweet",               limit: 65535
    t.integer  "deprecated_event_id",               null: false
    t.datetime "created_at",                        null: false
    t.datetime "updated_at",                        null: false
    t.index ["deprecated_event_id"], name: "index_deprecated_sns_events_on_deprecated_event_id", using: :btree
  end

  create_table "discussion_categories", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC" do |t|
    t.string   "title"
    t.integer  "project_id",                    null: false
    t.integer  "discussions_count", default: 0, null: false
    t.datetime "created_at",                    null: false
    t.datetime "updated_at",                    null: false
    t.index ["project_id"], name: "index_discussion_categories_on_project_id", using: :btree
    t.index ["title", "project_id"], name: "index_discussion_categories_on_title_and_project_id", unique: true, using: :btree
  end

  create_table "discussions", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC" do |t|
    t.string   "title"
    t.text     "body",                   limit: 65535
    t.integer  "user_id"
    t.integer  "project_id"
    t.datetime "created_at",                                       null: false
    t.datetime "updated_at",                                       null: false
    t.integer  "likes_count",                          default: 0
    t.integer  "views_count",                          default: 0
    t.integer  "anonymous_likes_count",                default: 0
    t.integer  "discussion_category_id"
    t.datetime "pinned_at"
    t.index ["discussion_category_id"], name: "index_discussions_on_discussion_category_id", using: :btree
    t.index ["project_id"], name: "index_discussions_on_project_id", using: :btree
    t.index ["user_id"], name: "index_discussions_on_user_id", using: :btree
  end

  create_table "election_candidates", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC" do |t|
    t.integer "agent_id"
    t.string  "candidate_category"
    t.string  "district_name"
    t.string  "party"
    t.string  "image_url"
    t.string  "name"
    t.string  "election_slug"
    t.string  "election_category"
    t.string  "election_code"
    t.string  "area_division"
    t.string  "area_division_code"
    t.string  "district_slug"
    t.string  "district_code"
    t.index ["agent_id"], name: "index_election_candidates_on_agent_id", using: :btree
  end

  create_table "elections", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC" do |t|
    t.string   "slug",       null: false
    t.string   "title"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["slug"], name: "index_elections_on_slug", using: :btree
  end

  create_table "email_subscriptions", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC" do |t|
    t.string   "email"
    t.boolean  "use"
    t.string   "mailerable_type"
    t.integer  "mailerable_id"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
    t.index ["mailerable_type", "mailerable_id"], name: "index_email_subscriptions_on_mailerable_type_and_mailerable_id", using: :btree
  end

  create_table "feedbacks", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC" do |t|
    t.integer  "user_id",    null: false
    t.integer  "survey_id",  null: false
    t.integer  "option_id",  null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["option_id"], name: "index_feedbacks_on_option_id", using: :btree
    t.index ["survey_id"], name: "index_feedbacks_on_survey_id", using: :btree
    t.index ["user_id"], name: "index_feedbacks_on_user_id", using: :btree
  end

  create_table "following_issues", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC" do |t|
    t.integer  "issue_id",   null: false
    t.integer  "user_id",    null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["issue_id", "user_id"], name: "index_following_issues_on_issue_id_and_user_id", unique: true, using: :btree
    t.index ["issue_id"], name: "index_following_issues_on_issue_id", using: :btree
    t.index ["user_id"], name: "index_following_issues_on_user_id", using: :btree
  end

  create_table "friendly_id_slugs", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC" do |t|
    t.string   "slug",                      null: false
    t.integer  "sluggable_id",              null: false
    t.string   "sluggable_type", limit: 50
    t.string   "scope"
    t.datetime "created_at"
    t.index ["slug", "sluggable_type", "scope"], name: "index_friendly_id_slugs_on_slug_and_sluggable_type_and_scope", unique: true, using: :btree
    t.index ["slug", "sluggable_type"], name: "index_friendly_id_slugs_on_slug_and_sluggable_type", using: :btree
    t.index ["sluggable_id"], name: "index_friendly_id_slugs_on_sluggable_id", using: :btree
    t.index ["sluggable_type"], name: "index_friendly_id_slugs_on_sluggable_type", using: :btree
  end

  create_table "issue_mailings", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC" do |t|
    t.integer  "issue_id"
    t.string   "source_type"
    t.integer  "source_id"
    t.string   "action",      null: false
    t.datetime "deleted_at"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.index ["issue_id"], name: "index_issue_mailings_on_issue_id", using: :btree
    t.index ["source_type", "source_id"], name: "index_issue_mailings_on_source_type_and_source_id", using: :btree
  end

  create_table "issues", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC" do |t|
    t.string   "title"
    t.integer  "following_issues_count",               default: 0
    t.datetime "created_at",                                           null: false
    t.datetime "updated_at",                                           null: false
    t.integer  "deprecated_agenda_id"
    t.text     "body",                   limit: 65535
    t.boolean  "has_stance",                           default: false
    t.integer  "agenda_theme_id"
    t.string   "image"
    t.index ["agenda_theme_id"], name: "index_issues_on_agenda_theme_id", using: :btree
    t.index ["deprecated_agenda_id"], name: "index_issues_on_deprecated_agenda_id", using: :btree
    t.index ["title"], name: "index_issues_on_title", unique: true, using: :btree
  end

  create_table "likes", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC" do |t|
    t.integer  "user_id",      null: false
    t.string   "likable_type"
    t.integer  "likable_id",   null: false
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
    t.index ["likable_type", "likable_id"], name: "index_likes_on_likable_type_and_likable_id", using: :btree
    t.index ["user_id"], name: "index_likes_on_user_id", using: :btree
  end

  create_table "memorials", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC" do |t|
    t.string   "title"
    t.text     "body",                  limit: 65535
    t.integer  "user_id"
    t.datetime "created_at",                                      null: false
    t.datetime "updated_at",                                      null: false
    t.integer  "likes_count",                         default: 0
    t.integer  "comments_count",                      default: 0
    t.string   "image"
    t.string   "url"
    t.integer  "anonymous_likes_count",               default: 0
    t.index ["user_id"], name: "index_memorials_on_user_id", using: :btree
  end

  create_table "notes", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC" do |t|
    t.integer  "user_id"
    t.integer  "opinion_id",                                          null: false
    t.text     "body",                  limit: 65535
    t.string   "choice"
    t.string   "writer_name"
    t.string   "writer_email"
    t.integer  "reports_count",                       default: 0
    t.integer  "likes_count",                         default: 0
    t.integer  "anonymous_likes_count",               default: 0
    t.boolean  "sent_email",                          default: false
    t.datetime "created_at",                                          null: false
    t.datetime "updated_at",                                          null: false
    t.index ["opinion_id"], name: "index_notes_on_opinion_id", using: :btree
    t.index ["user_id"], name: "index_notes_on_user_id", using: :btree
  end

  create_table "npos_addtional_archive_documents", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC" do |t|
    t.string   "address"
    t.string   "npo_type"
    t.string   "zipcode"
    t.string   "homepage"
    t.string   "tel"
    t.string   "leader"
    t.string   "leader_tel"
    t.string   "email"
    t.string   "business_area"
    t.string   "open_year"
    t.integer  "members_count"
    t.integer  "workers_count"
    t.integer  "finance"
    t.datetime "created_at",          null: false
    t.datetime "updated_at",          null: false
    t.integer  "archive_document_id", null: false
    t.string   "fax"
    t.string   "sub_region"
    t.index ["archive_document_id"], name: "index_npos_addtional_archive_documents_on_archive_document_id", using: :btree
  end

  create_table "opinions", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC" do |t|
    t.string   "quote"
    t.text     "body",                  limit: 65535
    t.integer  "agent_id"
    t.integer  "issue_id"
    t.datetime "created_at",                                      null: false
    t.datetime "updated_at",                                      null: false
    t.integer  "likes_count",                         default: 0
    t.integer  "anonymous_likes_count",               default: 0
    t.integer  "votes_count",                         default: 0
    t.integer  "agrees_count",                        default: 0
    t.integer  "disagrees_count",                     default: 0
    t.string   "stance"
    t.index ["agent_id"], name: "index_opinions_on_agent_id", using: :btree
    t.index ["issue_id"], name: "index_opinions_on_issue_id", using: :btree
  end

  create_table "options", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC" do |t|
    t.integer  "survey_id",                                           null: false
    t.text     "body",                      limit: 65535
    t.integer  "feedbacks_count",                         default: 0, null: false
    t.datetime "created_at",                                          null: false
    t.datetime "updated_at",                                          null: false
    t.string   "desc"
    t.integer  "anonymous_feedbacks_count",               default: 0
    t.index ["survey_id"], name: "index_options_on_survey_id", using: :btree
  end

  create_table "orders", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC" do |t|
    t.integer  "comment_id"
    t.integer  "agent_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "read_at"
    t.index ["agent_id"], name: "index_orders_on_agent_id", using: :btree
    t.index ["comment_id", "agent_id"], name: "comments_target_speakers_uk", unique: true, using: :btree
    t.index ["comment_id"], name: "index_orders_on_comment_id", using: :btree
  end

  create_table "organizations", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC" do |t|
    t.integer  "user_id"
    t.string   "title",                             null: false
    t.text     "description",         limit: 65535
    t.string   "slug",                              null: false
    t.string   "logo"
    t.datetime "created_at",                        null: false
    t.datetime "updated_at",                        null: false
    t.string   "site_name"
    t.string   "slogan"
    t.string   "community_url"
    t.string   "single_project_slug"
    t.index ["user_id"], name: "index_organizations_on_user_id", using: :btree
  end

  create_table "organizers", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC" do |t|
    t.integer "user_id"
    t.string  "organizable_type", null: false
    t.integer "organizable_id",   null: false
    t.index ["organizable_type", "organizable_id"], name: "index_organizers_on_organizable_type_and_organizable_id", using: :btree
    t.index ["user_id", "organizable_id", "organizable_type"], name: "index_project_admins_on_user_and_adminable", unique: true, using: :btree
    t.index ["user_id"], name: "index_organizers_on_user_id", using: :btree
  end

  create_table "participations", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC" do |t|
    t.integer  "user_id",    null: false
    t.integer  "project_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["project_id"], name: "index_participations_on_project_id", using: :btree
    t.index ["user_id", "project_id"], name: "index_participations_on_user_id_and_project_id", unique: true, using: :btree
    t.index ["user_id"], name: "index_participations_on_user_id", using: :btree
  end

  create_table "people", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC" do |t|
    t.string   "name",                     null: false
    t.text     "body",       limit: 65535
    t.string   "image"
    t.integer  "user_id",                  null: false
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
    t.index ["user_id"], name: "index_people_on_user_id", using: :btree
  end

  create_table "players", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC" do |t|
    t.integer  "person_id",                       null: false
    t.integer  "user_id",                         null: false
    t.integer  "race_id",                         null: false
    t.integer  "thumbs_up_count",     default: 0
    t.integer  "thumbs_down_count",   default: 0
    t.integer  "thumbs_middle_count", default: 0
    t.datetime "created_at",                      null: false
    t.datetime "updated_at",                      null: false
    t.index ["person_id"], name: "index_players_on_person_id", using: :btree
    t.index ["race_id", "person_id"], name: "index_players_on_race_id_and_person_id", unique: true, using: :btree
    t.index ["race_id"], name: "index_players_on_race_id", using: :btree
    t.index ["user_id"], name: "index_players_on_user_id", using: :btree
  end

  create_table "polls", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC" do |t|
    t.string   "title"
    t.text     "body",                  limit: 65535
    t.integer  "user_id"
    t.integer  "project_id"
    t.datetime "created_at",                                      null: false
    t.datetime "updated_at",                                      null: false
    t.integer  "likes_count",                         default: 0
    t.integer  "votes_count",                         default: 0
    t.integer  "agrees_count",                        default: 0
    t.integer  "disagrees_count",                     default: 0
    t.integer  "views_count",                         default: 0
    t.string   "social_card"
    t.string   "cover_image"
    t.integer  "anonymous_likes_count",               default: 0
    t.integer  "neutrals_count",                      default: 0, null: false
    t.index ["project_id"], name: "index_polls_on_project_id", using: :btree
    t.index ["user_id"], name: "index_polls_on_user_id", using: :btree
  end

  create_table "positions", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC" do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "project_categories", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC" do |t|
    t.integer "organization_id", null: false
    t.string  "slug",            null: false
    t.string  "title",           null: false
    t.index ["organization_id"], name: "index_project_categories_on_organization_id", using: :btree
    t.index ["slug"], name: "index_project_categories_on_slug", using: :btree
  end

  create_table "projects", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC" do |t|
    t.string   "title"
    t.text     "body",                      limit: 65535
    t.integer  "user_id"
    t.datetime "created_at",                                             null: false
    t.datetime "updated_at",                                             null: false
    t.integer  "views_count",                             default: 0
    t.string   "image"
    t.boolean  "discussion_enabled",                      default: true
    t.boolean  "campaign_enabled",                        default: true
    t.boolean  "poll_enabled",                            default: true
    t.boolean  "wiki_enabled",                            default: true
    t.string   "discussion_title"
    t.string   "poll_title"
    t.string   "campaign_title"
    t.string   "wiki_title"
    t.string   "slug",                                                   null: false
    t.boolean  "survey_enabled",                          default: true
    t.string   "survey_title"
    t.string   "subtitle"
    t.integer  "discussion_sequence",                     default: 0
    t.integer  "campaign_sequence",                       default: 0
    t.integer  "poll_sequence",                           default: 0
    t.integer  "wiki_sequence",                           default: 0
    t.integer  "deprecated_event_sequence",               default: 0
    t.string   "social_image"
    t.integer  "organization_id"
    t.boolean  "story_enabled",                           default: true
    t.string   "story_title"
    t.integer  "story_sequence",                          default: 0
    t.integer  "project_category_id"
    t.string   "deprecated_event_title"
    t.boolean  "townhall_enabled",                        default: true
    t.string   "townhall_title"
    t.integer  "townhall_sequence"
    t.integer  "townhall_id"
    t.boolean  "deprecated_event_enabled",                default: true
    t.index ["organization_id"], name: "index_projects_on_organization_id", using: :btree
    t.index ["project_category_id"], name: "index_projects_on_project_category_id", using: :btree
    t.index ["user_id"], name: "index_projects_on_user_id", using: :btree
  end

  create_table "races", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC" do |t|
    t.string   "title",                    null: false
    t.text     "body",       limit: 65535
    t.integer  "user_id",                  null: false
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
    t.index ["user_id"], name: "index_races_on_user_id", using: :btree
  end

  create_table "redactor2_assets", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC" do |t|
    t.integer  "user_id"
    t.string   "data_file_name"
    t.string   "data_content_type"
    t.integer  "data_file_size"
    t.integer  "assetable_id"
    t.string   "assetable_type",    limit: 30
    t.string   "type",              limit: 30
    t.integer  "width"
    t.integer  "height"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["assetable_type", "assetable_id"], name: "idx_redactor2_assetable", using: :btree
    t.index ["assetable_type", "type", "assetable_id"], name: "idx_redactor2_assetable_type", using: :btree
  end

  create_table "reports", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC" do |t|
    t.string   "reportable_type"
    t.integer  "reportable_id",   null: false
    t.integer  "user_id",         null: false
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
    t.boolean  "force"
    t.index ["reportable_id", "reportable_type", "user_id"], name: "index_reports_on_reportable_id_and_reportable_type_and_user_id", unique: true, using: :btree
    t.index ["reportable_type", "reportable_id"], name: "index_reports_on_reportable_type_and_reportable_id", using: :btree
    t.index ["user_id"], name: "index_reports_on_user_id", using: :btree
  end

  create_table "roles", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC" do |t|
    t.string   "name"
    t.string   "resource_type"
    t.integer  "resource_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["name", "resource_type", "resource_id"], name: "index_roles_on_name_and_resource_type_and_resource_id", using: :btree
    t.index ["name"], name: "index_roles_on_name", using: :btree
  end

  create_table "sent_requests", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC" do |t|
    t.integer  "agent_id"
    t.integer  "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer  "agenda_id"
    t.index ["agenda_id"], name: "index_sent_requests_on_agenda_id", using: :btree
    t.index ["agent_id"], name: "index_sent_requests_on_agent_id", using: :btree
    t.index ["user_id"], name: "index_sent_requests_on_user_id", using: :btree
  end

  create_table "signer_emails", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC" do |t|
    t.string   "title"
    t.text     "body",        limit: 65535
    t.boolean  "draft",                     default: true
    t.integer  "user_id"
    t.integer  "campaign_id"
    t.datetime "created_at",                               null: false
    t.datetime "updated_at",                               null: false
    t.index ["campaign_id"], name: "index_signer_emails_on_campaign_id", using: :btree
    t.index ["user_id"], name: "index_signer_emails_on_user_id", using: :btree
  end

  create_table "signs", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC" do |t|
    t.integer  "user_id"
    t.integer  "campaign_id",                                                              null: false
    t.text     "body",                  limit: 65535
    t.datetime "created_at",                                                               null: false
    t.datetime "updated_at",                                                               null: false
    t.string   "signer_name"
    t.string   "signer_email"
    t.integer  "reports_count",                       default: 0
    t.boolean  "extra_29_confirm_join",               default: false
    t.string   "signer_real_name"
    t.string   "signer_address"
    t.string   "signer_phone"
    t.boolean  "subscribed",                          default: true
    t.datetime "subscribed_at",                       default: -> { "CURRENT_TIMESTAMP" }
    t.index ["campaign_id"], name: "index_signs_on_campaign_id", using: :btree
    t.index ["user_id", "campaign_id"], name: "index_signs_on_user_id_and_campaign_id", unique: true, using: :btree
    t.index ["user_id"], name: "index_signs_on_user_id", using: :btree
  end

  create_table "speeches", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC" do |t|
    t.string   "title",                                 null: false
    t.string   "video_url",                             null: false
    t.integer  "deprecated_event_id",                   null: false
    t.integer  "user_id"
    t.datetime "created_at",                            null: false
    t.datetime "updated_at",                            null: false
    t.integer  "likes_count",           default: 0
    t.integer  "anonymous_likes_count", default: 0
    t.integer  "cached_view_count",     default: 0
    t.datetime "view_count_cached_at"
    t.boolean  "is_expired_view_count", default: false
    t.integer  "campaign_id",                           null: false
    t.index ["campaign_id"], name: "index_speeches_on_campaign_id", using: :btree
    t.index ["deprecated_event_id"], name: "index_speeches_on_deprecated_event_id", using: :btree
    t.index ["user_id"], name: "index_speeches_on_user_id", using: :btree
  end

  create_table "statement_keys", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC" do |t|
    t.integer  "statement_id", null: false
    t.string   "key",          null: false
    t.datetime "expired_at",   null: false
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
    t.index ["key"], name: "index_statement_keys_on_key", using: :btree
    t.index ["statement_id"], name: "index_statement_keys_on_statement_id", using: :btree
  end

  create_table "statements", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC" do |t|
    t.integer  "agent_id",                                              null: false
    t.text     "body",                 limit: 65535
    t.string   "stance",                             default: "unsure"
    t.datetime "created_at",                                            null: false
    t.datetime "updated_at",                                            null: false
    t.string   "statementable_type"
    t.integer  "statementable_id"
    t.integer  "last_updated_user_id"
    t.index ["agent_id"], name: "index_statements_on_agent_id", using: :btree
    t.index ["statementable_type", "statementable_id"], name: "index_statements_on_statementable_type_and_statementable_id", using: :btree
  end

  create_table "stories", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC" do |t|
    t.string   "title",                                              null: false
    t.text     "body",                  limit: 65535
    t.integer  "user_id"
    t.integer  "project_id"
    t.string   "cover"
    t.integer  "reports_count",                       default: 0
    t.integer  "likes_count",                         default: 0
    t.integer  "views_count",                         default: 0
    t.integer  "anonymous_likes_count",               default: 0
    t.boolean  "comment_enabled",                     default: true
    t.datetime "created_at",                                         null: false
    t.datetime "updated_at",                                         null: false
    t.datetime "published_at",                                       null: false
    t.index ["project_id"], name: "index_stories_on_project_id", using: :btree
    t.index ["user_id"], name: "index_stories_on_user_id", using: :btree
  end

  create_table "surveys", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC" do |t|
    t.string   "title"
    t.text     "body",                   limit: 65535
    t.integer  "user_id",                                              null: false
    t.integer  "project_id"
    t.integer  "likes_count",                          default: 0
    t.integer  "anonymous_likes_count",                default: 0
    t.integer  "feedbacks_count",                      default: 0,     null: false
    t.integer  "views_count",                          default: 0,     null: false
    t.integer  "duration",                             default: 0,     null: false
    t.string   "cover_image"
    t.string   "social_card"
    t.datetime "created_at",                                           null: false
    t.datetime "updated_at",                                           null: false
    t.boolean  "multi_selectable",                     default: false, null: false
    t.boolean  "anonymous_feedbackable",               default: false
    t.index ["project_id"], name: "index_surveys_on_project_id", using: :btree
    t.index ["user_id"], name: "index_surveys_on_user_id", using: :btree
  end

  create_table "sympathies", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC" do |t|
    t.string   "title",                                    null: false
    t.text     "body",           limit: 65535
    t.integer  "user_id"
    t.integer  "views_count",                  default: 0
    t.integer  "comments_count",               default: 0
    t.string   "cover_image"
    t.string   "social_image"
    t.datetime "created_at",                               null: false
    t.datetime "updated_at",                               null: false
    t.index ["user_id"], name: "index_sympathies_on_user_id", using: :btree
  end

  create_table "taggings", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC" do |t|
    t.integer  "tag_id"
    t.string   "taggable_type"
    t.integer  "taggable_id"
    t.string   "tagger_type"
    t.integer  "tagger_id"
    t.string   "context",       limit: 128
    t.datetime "created_at"
    t.index ["context"], name: "index_taggings_on_context", using: :btree
    t.index ["tag_id", "taggable_id", "taggable_type", "context", "tagger_id", "tagger_type"], name: "taggings_idx", unique: true, using: :btree
    t.index ["tag_id"], name: "index_taggings_on_tag_id", using: :btree
    t.index ["taggable_id", "taggable_type", "context"], name: "index_taggings_on_taggable_id_and_taggable_type_and_context", using: :btree
    t.index ["taggable_id", "taggable_type", "tagger_id", "context"], name: "taggings_idy", using: :btree
    t.index ["taggable_id"], name: "index_taggings_on_taggable_id", using: :btree
    t.index ["taggable_type"], name: "index_taggings_on_taggable_type", using: :btree
    t.index ["tagger_id", "tagger_type"], name: "index_taggings_on_tagger_id_and_tagger_type", using: :btree
    t.index ["tagger_id"], name: "index_taggings_on_tagger_id", using: :btree
  end

  create_table "tags", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC" do |t|
    t.string  "name"
    t.integer "taggings_count", default: 0
    t.index ["name"], name: "index_tags_on_name", unique: true, using: :btree
  end

  create_table "thumb_stats", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC" do |t|
    t.integer  "race_id",                       null: false
    t.integer  "player_id",                     null: false
    t.integer  "thumbs_up_count",   default: 0
    t.integer  "thumbs_down_count", default: 0
    t.date     "stated_at"
    t.datetime "created_at",                    null: false
    t.datetime "updated_at",                    null: false
    t.index ["player_id"], name: "index_thumb_stats_on_player_id", using: :btree
    t.index ["race_id"], name: "index_thumb_stats_on_race_id", using: :btree
  end

  create_table "thumbs", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC" do |t|
    t.integer  "user_id"
    t.string   "thumbable_type"
    t.integer  "thumbable_id"
    t.string   "direction",      null: false
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
    t.index ["thumbable_type", "thumbable_id"], name: "index_thumbs_on_thumbable_type_and_thumbable_id", using: :btree
    t.index ["user_id", "thumbable_id", "thumbable_type"], name: "index_thumbs_on_user_id_and_thumbable_id_and_thumbable_type", unique: true, using: :btree
    t.index ["user_id"], name: "index_thumbs_on_user_id", using: :btree
  end

  create_table "timeline_documents", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC" do |t|
    t.string   "title"
    t.text     "body",                  limit: 65535
    t.date     "date"
    t.string   "time"
    t.integer  "user_id",                                         null: false
    t.integer  "timeline_id",                                     null: false
    t.integer  "comments_count",                      default: 0
    t.integer  "likes_count",                         default: 0
    t.datetime "created_at",                                      null: false
    t.datetime "updated_at",                                      null: false
    t.string   "image"
    t.string   "source_url"
    t.string   "media_url"
    t.string   "media_credit"
    t.integer  "anonymous_likes_count",               default: 0
    t.index ["timeline_id"], name: "index_timeline_documents_on_timeline_id", using: :btree
    t.index ["user_id"], name: "index_timeline_documents_on_user_id", using: :btree
  end

  create_table "timelines", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC" do |t|
    t.string   "title"
    t.text     "body",                  limit: 65535
    t.string   "image"
    t.integer  "user_id",                                         null: false
    t.integer  "comments_count",                      default: 0
    t.integer  "likes_count",                         default: 0
    t.datetime "created_at",                                      null: false
    t.datetime "updated_at",                                      null: false
    t.string   "banner_image"
    t.string   "banner_url"
    t.integer  "anonymous_likes_count",               default: 0
    t.integer  "timeline_initial_zoom"
    t.index ["user_id"], name: "index_timelines_on_user_id", using: :btree
  end

  create_table "users", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC" do |t|
    t.string   "email"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                              default: 0,    null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.string   "provider"
    t.string   "uid"
    t.string   "nickname"
    t.string   "image"
    t.datetime "created_at",                                                null: false
    t.datetime "updated_at",                                                null: false
    t.string   "encrypted_password"
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string   "unconfirmed_email"
    t.text     "description",                  limit: 65535
    t.boolean  "enable_mailing",                             default: true
    t.string   "google_access_token"
    t.string   "google_refresh_token"
    t.string   "site_info"
    t.string   "facebook_info"
    t.string   "twitter_info"
    t.datetime "issues_summary_email_sent_at"
    t.index ["provider", "uid"], name: "index_users_on_provider_and_uid", unique: true, using: :btree
  end

  create_table "users_roles", id: false, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC" do |t|
    t.integer "user_id"
    t.integer "role_id"
    t.index ["user_id", "role_id"], name: "index_users_roles_on_user_id_and_role_id", using: :btree
  end

  create_table "voteaward_awards", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC" do |t|
    t.string   "title"
    t.text     "prize",                 limit: 65535
    t.text     "content",               limit: 65535
    t.string   "address"
    t.string   "promise_ids"
    t.string   "oid",                                 null: false
    t.integer  "voteaward_election_id"
    t.integer  "voteaward_user_id"
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
    t.index ["oid"], name: "idx_voteaward_awards_oid", using: :btree
    t.index ["voteaward_election_id"], name: "index_voteaward_awards_on_voteaward_election_id", using: :btree
    t.index ["voteaward_user_id"], name: "index_voteaward_awards_on_voteaward_user_id", using: :btree
  end

  create_table "voteaward_campaigns", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC" do |t|
    t.string   "title"
    t.string   "description"
    t.string   "image_filename"
    t.string   "url"
    t.string   "oid",                    null: false
    t.integer  "voteaward_candidate_id"
    t.integer  "voteaward_user_id"
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
    t.index ["oid"], name: "idx_voteaward_campaigns_oid", using: :btree
    t.index ["voteaward_candidate_id"], name: "index_voteaward_campaigns_on_voteaward_candidate_id", using: :btree
    t.index ["voteaward_user_id"], name: "index_voteaward_campaigns_on_voteaward_user_id", using: :btree
  end

  create_table "voteaward_candidates", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC" do |t|
    t.string   "name"
    t.string   "number"
    t.string   "party"
    t.string   "oid",                   null: false
    t.integer  "voteaward_election_id"
    t.datetime "created_at",            null: false
    t.datetime "updated_at",            null: false
    t.index ["oid"], name: "idx_voteaward_candidates_oid", using: :btree
    t.index ["voteaward_election_id"], name: "index_voteaward_candidates_on_voteaward_election_id", using: :btree
  end

  create_table "voteaward_comments", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC" do |t|
    t.string   "content"
    t.string   "oid",               null: false
    t.string   "commentable_type"
    t.integer  "commentable_id"
    t.integer  "voteaward_user_id"
    t.datetime "created_at",        null: false
    t.datetime "updated_at",        null: false
    t.index ["commentable_id"], name: "index_voteaward_comments_on_commentable_id", using: :btree
    t.index ["oid"], name: "idx_voteaward_comments_oid", using: :btree
    t.index ["voteaward_user_id"], name: "index_voteaward_comments_on_voteaward_user_id", using: :btree
  end

  create_table "voteaward_elections", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC" do |t|
    t.string   "title"
    t.string   "content"
    t.string   "oid",        null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["oid"], name: "idx_voteaward_elections_oid", using: :btree
  end

  create_table "voteaward_events", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC" do |t|
    t.string   "title"
    t.text     "content",               limit: 65535
    t.string   "address"
    t.text     "coordinates",           limit: 65535
    t.string   "image_filename"
    t.integer  "likes"
    t.integer  "limit"
    t.string   "oid",                                 null: false
    t.integer  "voteaward_election_id"
    t.integer  "voteaward_user_id"
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
    t.index ["oid"], name: "idx_voteaward_events_oid", using: :btree
    t.index ["voteaward_election_id"], name: "index_voteaward_events_on_voteaward_election_id", using: :btree
    t.index ["voteaward_user_id"], name: "index_voteaward_events_on_voteaward_user_id", using: :btree
  end

  create_table "voteaward_giveups", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC" do |t|
    t.integer  "age"
    t.string   "area"
    t.string   "reason"
    t.string   "sex"
    t.string   "oid",               null: false
    t.integer  "voteaward_user_id"
    t.datetime "created_at",        null: false
    t.datetime "updated_at",        null: false
    t.index ["oid"], name: "idx_voteaward_giveups_oid", using: :btree
    t.index ["voteaward_user_id"], name: "index_voteaward_giveups_on_voteaward_user_id", using: :btree
  end

  create_table "voteaward_promises", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC" do |t|
    t.integer  "age"
    t.string   "area"
    t.string   "award_ids"
    t.integer  "likes"
    t.string   "reason"
    t.integer  "seq"
    t.string   "sex"
    t.boolean  "show_candidate"
    t.string   "oid",                    null: false
    t.integer  "voteaward_election_id"
    t.integer  "voteaward_candidate_id"
    t.integer  "voteaward_user_id"
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
    t.index ["oid"], name: "idx_voteaward_promises_oid", using: :btree
    t.index ["voteaward_candidate_id"], name: "index_voteaward_promises_on_voteaward_candidate_id", using: :btree
    t.index ["voteaward_election_id"], name: "index_voteaward_promises_on_voteaward_election_id", using: :btree
    t.index ["voteaward_user_id"], name: "index_voteaward_promises_on_voteaward_user_id", using: :btree
  end

  create_table "voteaward_users", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC" do |t|
    t.string   "name"
    t.string   "password"
    t.string   "email"
    t.string   "oid",                 null: false
    t.string   "omniauth"
    t.string   "omniauth_token"
    t.string   "omniauth_expires_at"
    t.boolean  "omniauth_expires"
    t.string   "omniauth_image"
    t.string   "omniauth_provider",   null: false
    t.string   "omniauth_uid",        null: false
    t.string   "omniauth_url"
    t.integer  "user_id"
    t.datetime "created_at",          null: false
    t.datetime "updated_at",          null: false
    t.index ["oid"], name: "idx_voteaward_users_oid", using: :btree
    t.index ["omniauth_provider", "omniauth_uid"], name: "idx_voteaward_users_uid", using: :btree
  end

  create_table "voteaward_votes", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC" do |t|
    t.string   "title"
    t.text     "content",               limit: 65535
    t.text     "coordinates",           limit: 65535
    t.string   "image_filename"
    t.integer  "likes"
    t.integer  "seq"
    t.string   "oid",                                 null: false
    t.integer  "voteaward_event_id"
    t.integer  "voteaward_election_id"
    t.integer  "voteaward_user_id"
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
    t.index ["oid"], name: "idx_voteaward_votes_oid", using: :btree
    t.index ["voteaward_election_id"], name: "index_voteaward_votes_on_voteaward_election_id", using: :btree
    t.index ["voteaward_event_id"], name: "index_voteaward_votes_on_voteaward_event_id", using: :btree
    t.index ["voteaward_user_id"], name: "index_voteaward_votes_on_voteaward_user_id", using: :btree
  end

  create_table "votes", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC" do |t|
    t.integer  "user_id"
    t.string   "choice"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
    t.string   "votable_type", null: false
    t.integer  "votable_id",   null: false
    t.index ["user_id", "votable_id", "votable_type"], name: "index_votes_on_user_id_and_votable_id_and_votable_type", unique: true, using: :btree
    t.index ["user_id"], name: "index_votes_on_user_id", using: :btree
    t.index ["votable_type", "votable_id"], name: "index_votes_on_votable_type_and_votable_id", using: :btree
  end

  create_table "wiki_revisions", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC" do |t|
    t.integer  "wiki_id",                  null: false
    t.integer  "user_id",                  null: false
    t.text     "body",       limit: 65535
    t.text     "note",       limit: 65535
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
    t.index ["user_id"], name: "index_wiki_revisions_on_user_id", using: :btree
    t.index ["wiki_id"], name: "index_wiki_revisions_on_wiki_id", using: :btree
  end

  create_table "wikis", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC" do |t|
    t.string   "title"
    t.text     "body",                  limit: 65535
    t.integer  "user_id",                                         null: false
    t.integer  "project_id",                                      null: false
    t.integer  "views_count",                         default: 0
    t.integer  "comments_count",                      default: 0
    t.integer  "likes_count",                         default: 0
    t.datetime "created_at",                                      null: false
    t.datetime "updated_at",                                      null: false
    t.integer  "anonymous_likes_count",               default: 0
    t.index ["project_id"], name: "index_wikis_on_project_id", using: :btree
    t.index ["user_id"], name: "index_wikis_on_user_id", using: :btree
  end

  add_foreign_key "sent_requests", "agents"
  add_foreign_key "sent_requests", "users"
end
