# -*- coding: utf-8 -*-
require "faraday"
module Jekyll
  class MembersPage < Page
    def initialize(site, base, dir, member_list)
      @site = site
      @base = base
      @dir  = dir
      @name = 'index.html'
      self.process(@name)
      self.read_yaml(File.join(base, '_layouts'), 'members_index.html')
      self.data['member_list'] = member_list
    end
  end

  class MembersPageGenerator < Generator
    safe true
    def generate(site)
      return if !site.config['members_page'] || !site.config['member_list_url']
      uri = URI.parse(site.config['member_list_url'])
      response = Faraday.new("#{uri.scheme}://#{uri.host}").get(uri.path)
      member_list = YAML.load(response.body)
      site.pages << MembersPage.new(site, site.source, 'members', member_list)
    end
  end
end
