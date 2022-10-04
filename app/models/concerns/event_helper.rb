module EventHelper
  def fire_later(event, wait: nil, wait_until: nil)
    EventFiringJob.set(wait: wait, wait_until: wait_until).perform_later(self, event: event.to_s)
  end
end
