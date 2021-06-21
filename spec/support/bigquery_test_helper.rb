module BigqueryTestHelper
  def stub_bigquery_table
    table = instance_double(Google::Cloud::Bigquery::Table)
    dataset = instance_double(Google::Cloud::Bigquery::Dataset, table: table)
    project = instance_double(Google::Cloud::Bigquery::Project, dataset: dataset)

    allow(Google::Cloud::Bigquery).to receive(:new).and_return(project)

    table
  end
end
