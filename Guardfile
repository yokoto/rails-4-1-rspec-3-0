guard :minitest, test_folders: 'test', all_on_start: false, spring: true do
  # テストファイルの監視
  watch(%r{^test/.+_test\.rb$})
  # libファイルの監視
  watch(%r{^lib/(.+)\.rb$}) \
    { |m| "test/lib/#{m[1]}_test.rb" }
  # test_helperの監視
  watch('test/test_helper.rb') \
    { "test" }

  # app以下の各ファイルの監視
  watch(%r{^app/(.+)\.rb$}) \
    { |m| "test/#{m[1]}_test.rb" }
  # Viewの監視
  watch(%r{^app/(.*)(\.erb|\.haml)$}) \
    { |m| "test/#{m[1]}#{m[2]}_test.rb" }
  # Controllerの監視
  watch(%r{^app/controllers/(.+)_(controller)\.rb$}) \
    { |m| "test/#{m[2]}s/#{m[1]}_#{m[2]}_test.rb" }
  # test/support以下の監視
  watch(%r{^test/support/(.+)\.rb$}) \
    { "test" }
  # application_controllerの監視
  watch('app/controllers/application_controller.rb') \
    { "test/controllers" }

  # Viewの監視（フィーチャテスト実行）
  watch(%r{^app/views/(.+)/.*\.(erb|haml)$}) \
    { |m| "test/features/#{m[1]}_test.rb" }
end
