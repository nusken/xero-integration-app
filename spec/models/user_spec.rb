require 'rails_helper'

RSpec.describe User, type: :model do
  subject {
    FactoryBot.create(:user)
  }
  describe '#fetch_invoices_from_xero' do
    context 'when user is connected with Xero' do
      let(:xero_token_set) { { "connections" => [{ "tenantId" => "tenant_id_1" }, { "tenantId" => "tenant_id_2" }] } }
      let(:xero_service_double) { instance_double(XeroService, fetch_invoices: nil) }
      
      let(:sample_invoices) do
        [
          OpenStruct.new({
            invoice_id: 'invoice_1',
            amount_due: 100.0,
            total: 120.0,
            due_date: Date.today,
            status: 'Draft',
            contact: OpenStruct.new({
              name: 'Client 1',
              contact_id: 'client_1_id'
            })
          }),
          OpenStruct.new({
            invoice_id: 'invoice_2',
            amount_due: 110.0,
            total: 130.0,
            due_date: Date.today,
            status: 'Draft',
            contact: OpenStruct.new({
              name: 'Client 2',
              contact_id: 'client_2_id'
            })
          })
        ]
      end
      
      before do
        allow(subject).to receive(:connected_with_xero?).and_return(true)
        allow(subject).to receive(:xero_token_set).and_return(xero_token_set)
        allow(XeroService).to receive(:new).with(xero_token_set).and_return(xero_service_double)
        allow(xero_service_double).to receive(:fetch_invoices).with("tenant_id_1").and_yield(sample_invoices)
      end

      it 'fetches invoices from Xero for each tenant' do
        expect(xero_service_double).to receive(:fetch_invoices).with("tenant_id_1")
        expect(xero_service_double).to receive(:fetch_invoices).with("tenant_id_2")

        subject.fetch_invoices_from_xero
      end
      
      it 'creates records in the database' do
        expect { subject.fetch_invoices_from_xero }.to change(Invoice, :count).by(sample_invoices.length)

        # Verify that records were created with the expected data
        sample_invoices.each do |invoice_data|
          invoice = Invoice.find_by(xero_invoice_id: invoice_data[:invoice_id])
          expect(invoice).to have_attributes(
            outstanding_amount: invoice_data[:amount_due],
            total_amount: invoice_data[:total],
            due_date: invoice_data[:due_date],
            status: invoice_data[:status],
            client_name: invoice_data[:contact][:name],
            contact_id: invoice_data[:contact][:contact_id],
            tenant_id: "tenant_id_1"
          )
        end
      end
    end
    

    context 'when user is not connected with Xero' do
      before do
        allow(subject).to receive(:connected_with_xero?).and_return(false)
      end

      it 'does not fetch any invoices' do
        expect_any_instance_of(XeroService).not_to receive(:fetch_invoices)

        subject.fetch_invoices_from_xero
      end
    end
  end
end
