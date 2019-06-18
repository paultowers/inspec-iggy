# helpers for working with InSpec-GCP profiles

require 'yaml'

module InspecPlugins::Iggy::Platforms
  class GcpHelper

    # find the additional parameters
    GCP_RESOURCE_QUALIFIERS = {
      'google_bigquery_dataset' => [:project, :name],
      'google_bigquery_table' => [:project, :dataset, :name],
      'google_cloudfunctions_cloud_function' => [:project, :location, :name],
      'google_compute_address' => [:project, :location, :name],
      'google_compute_autoscaler' => [:project, :zone, :name],
      'google_compute_backend_bucket' => [:project, :name],
      'google_compute_backend_service' => [:project, :name],
      'google_compute_disk' => [:project, :name, :zone],
      'google_compute_firewall' => [:project, :name],
      'google_compute_forwarding_rule' => [:project, :region, :name],
      'google_compute_global_address' => [:project, :name],
      'google_compute_global_forwarding_rule' => [:project, :name],
      'google_compute_health_check' => [:project, :name],
      'google_compute_http_health_check' => [:project, :name],
      'google_compute_https_health_check' => [:project, :name],
      'google_compute_image' => [:project, :name],
      'google_compute_instance' => [:project, :zone, :name],
      'google_compute_instance_group' => [:project, :zone, :name],
      'google_compute_instance_group_manager' => [:project, :zone, :name],
      'google_compute_instance_template' => [:project, :name],
      'google_compute_network' => [:project, :name],
      'google_compute_project_info' => [:project],
      'google_compute_region' => [:project, :name],
      'google_compute_region_backend_service' => [:project, :region, :name],
      'google_compute_region_instance_group_manager' => [:project, :region, :name],
      'google_compute_route' => [:project, :name],
      'google_compute_router' => [:project, :region, :name],
      'google_compute_snapshot' => [:project, :name],
      'google_compute_ssl_certificate' => [:project, :name],
      'google_compute_ssl_policy' => [:project, :name],
      'google_compute_subnetwork' => [:project, :region, :name],
      'google_compute_subnetwork_iam_policy' => [:project, :region, :name],
      'google_compute_target_http_proxy' => [:project, :name],
      'google_compute_target_https_proxy' => [:project, :name],
      'google_compute_target_pool' => [:project, :region, :name],
      'google_compute_target_tcp_proxy' => [:project, :name],
      'google_compute_url_map' => [:project, :name],
      'google_compute_vpn_tunnel' => [:project, :region, :name],
      'google_compute_zone' => [:project, :zone],
      'google_container_cluster' => [:project, :zone, :name],
      'google_container_node_pool' => [:project, :zone, :cluster_name, :nodepool_name],
      'google_container_regional_cluster' => [:project, :location, :name],
      'google_container_regional_node_pool' => [:project, :location, :cluster, :name],
      'google_dns_managed_zone' => [:project, :zone],
      'google_dns_resource_record_set' => [:project, :name, :type, :managed_zone],
      'google_kms_crypto_key' => [:project, :location, :key_ring_name, :name],
      'google_kms_crypto_key_iam_binding' => [:crypto_key_url, :role],
      'google_kms_key_ring' => [:project, :location, :name],
      'google_kms_key_ring_iam_binding' => [:key_ring_url, :role],
      'google_logging_project_exclusion' => [:project, :exclusion],
      'google_logging_project_sink' => [:project, :sink],
      'google_organization' => [:display_name],
      'google_organization_policy' => [:name, :constraints],
      'google_project' => [:project],
      'google_project_alert_policy' => [:policy],
      'google_project_alert_policy_condition' => [:name, :filter],
      'google_project_iam_binding' => [:project, :role],
      'google_project_iam_custom_role' => [:project, :name],
      'google_project_logging_audit_config' => [:project],
      'google_project_metric' => [:project, :metric],
      'google_pubsub_subscription' => [:project, :name],
      'google_pubsub_subscription_iam_policy' => [:project, :name],
      'google_pubsub_topic' => [:project, :name],
      'google_pubsub_topic_iam_policy' => [:project, :name],
      'google_resourcemanager_organization_policy' => [:organization_name, :constraint],
      'google_service_account' => [:name],
      'google_service_account_key' => [:name],
      'google_sourcerepo_repository' => [:project, :name],
      'google_sql_database_instance' => [:project, :database],
      'google_storage_bucket' => [:name],
      'google_storage_bucket_acl' => [:bucket, :entity],
      'google_storage_bucket_iam_binding' => [:bucket, :role],
      'google_storage_bucket_object' => [:bucket, :object],
      'google_storage_default_object_acl' => [:bucket, :entity],
      'google_storage_object_acl' => [:bucket, :object, :entity],
      'google_user' => [:user_key]
    }.freeze

    GCP_REMOVED_PROPERTIES = {
      'google_compute_http_health_check' => [:self_link, :id], # id: terraform has name not id, self_link: undocumented but broken
    }

    # readme content
    def self.readme
    end

    # inspec.yml boilerplate content from
    # inspec/lib/plugins/inspec-init/templates/profiles/gcp/inspec.yml
    def self.inspec_yml
      yml = {}
      yml['inspec_version'] = '>= 2.3.5'
      yml['depends'] = [{
        'name' => 'inspec-gcp',
        'url' => 'https://github.com/inspec/inspec-gcp/archive/master.tar.gz',
      }]
      yml['supports'] = [{
        'platform' => 'gcp'
      }]
      return yml
    end
  end
end
