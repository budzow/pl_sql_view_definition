CREATE OR REPLACE FORCE VIEW chpont_sf_cust_contacts_v
(
    account_number,
    account_name,
    cust_account_id,
    party_id,
    contact_name,
    contact_first_name,
    contact_last_name,
    email_address,
    phone_area_code,
    phone_country_code,
    phone_number,
    phone_extension
)
AS
    SELECT DISTINCT hca.account_number,
                    hp_acct.party_name      AS       account_name,
                    hca.cust_account_id,
                    hp_acct.party_id,
                    hp_cntct.party_name    AS        contact_name,
                    hp_cntct.person_first_name   AS  contact_first_name,
                    hp_cntct.person_last_name   AS   contact_last_name,
                    hcp_email.email_address,
                    hcp_phone.phone_area_code,
                    hcp_phone.phone_country_code,
                    hcp_phone.phone_number,
                    hcp_phone.phone_extension
      FROM hz_parties              hp_cntct,
           hz_contact_points       hcp_email,
           hz_contact_points       hcp_phone,
           hz_cust_account_roles   hcar,
           hz_relationships        hr,
           hz_org_contacts         hoc,
           hz_cust_accounts_all    hca,
           hz_parties              hp_acct,
           hz_party_sites          hps,
           hz_cust_acct_sites_all  hcasa
     WHERE     hca.cust_account_id = hcar.cust_account_id
           AND hcar.cust_acct_site_id = hcasa.cust_acct_site_id(+)
           AND hps.party_site_id(+) = hcasa.party_site_id
           AND hca.party_id = hp_acct.party_id
           AND hp_acct.party_id = hps.party_id(+)
           AND hcar.party_id = hr.party_id
           AND hr.subject_table_name = 'HZ_PARTIES'
           AND hr.subject_type = 'PERSON'
           AND hr.relationship_code = 'CONTACT_OF'
           AND hr.party_id = hcp_email.owner_table_id(+)
           AND hcp_email.owner_table_name(+) = 'HZ_PARTIES'
           AND hcp_email.contact_point_type(+) = 'EMAIL'
           AND hr.party_id = hcp_phone.owner_table_id(+)
           AND hcp_phone.owner_table_name(+) = 'HZ_PARTIES'
           AND hcp_phone.contact_point_type(+) = 'PHONE'
           AND hr.subject_id = hp_cntct.party_id
           AND hr.relationship_id = hoc.party_relationship_id;