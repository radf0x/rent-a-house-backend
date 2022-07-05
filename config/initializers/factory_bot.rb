# frozen_string_literal: true

Proc.new do
  return unless defined?(FactoryBot)

  FactoryBot.definition_file_paths = [Rails.root.join('spec', 'factories')]
  ActiveSupport.on_load(:active_record) { FactoryBot.find_definitions }
end.call
