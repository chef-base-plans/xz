title 'Tests to confirm xz works as expected'

plan_name = input('plan_name', value: 'xz')
plan_ident = "#{ENV['HAB_ORIGIN']}/#{plan_name}"
hab_path = input('hab_path', value: 'hab')

control 'core-plans-xz' do
  impact 1.0
  title 'Ensure xz works'
  desc '
  For xz we check that the version is correctly returned e.g.

    $ xz --version
    xz (XZ Utils) 5.2.5
    liblzma 5.2.5
  '
  xz_pkg_ident = command("#{hab_path} pkg path #{plan_ident}")
  describe xz_pkg_ident do
    its('exit_status') { should eq 0 }
    its('stdout') { should_not be_empty }
  end
  xz_pkg_ident = xz_pkg_ident.stdout.strip

  describe command("#{xz_pkg_ident}/bin/xz --version") do
    its('exit_status') { should eq 0 }
    its('stdout') { should_not be_empty }
    its('stdout') { should match /xz \(XZ Utils\)\s+#{xz_pkg_ident.split('/')[5]}/ }
    its('stderr') { should be_empty }
  end
end
