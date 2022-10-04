class EventFiringJob < ApplicationJob
  queue_as :default
  discard_on AASM::InvalidTransition

  def perform(target, event:)
    aasm = target.aasm
    event = event.to_sym

    aasm.fire!(event)
  end
end
