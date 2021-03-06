# KeyValues
module Kvs

  class Base < ActiveHash::Base
    def self.id_options
      all.map {|t| [t.name, t.id]}
    end

    def self.code_options
      all.map {|t| [t.name, t.code]}
    end

    def self.id_hash
      Hash[*(all.map{|t| [t.id, t.name]}.flatten)]
    end

    def self.code_hash
      Hash[*(all.map{|t| [t.code, t.name]}.flatten)]
    end

    def self.attributes
      all.map {|t| t.attributes }
    end

    def self.find_by_code(code)
      super(code.to_s)
    end
  end

  module Observer
    class Type < Kvs::Base
      self.data = [
        { id: 1, code: ::Observer::Type::HTTPs,     name: I18n.t('observers.type.https') },
        { id: 2, code: ::Observer::Type::PING,      name: I18n.t('observers.type.ping') },
        { id: 3, code: ::Observer::Type::KEY_WORD,  name: I18n.t('observers.type.key_word') },
      ]
    end
  end

  module ObserverEvent
    class Type < Kvs::Base
      self.data = [
        { id: 1, code: ::ObserverEvent::Type::UP,     name: I18n.t('observer_events.type.up') },
        { id: 2, code: ::ObserverEvent::Type::DOWN,   name: I18n.t('observer_events.type.down') },
      ]
    end
  end

  class Region < Kvs::Base
    self.data = [
      { id: 1, code: ObserverRegion::Type::ASIA_EAST1, enable: true, continent: :asia, location: 'Changhua County, Taiwan' },
    ]
  end
end
