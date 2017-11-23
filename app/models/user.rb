class User < ApplicationRecord
  has_many :entity_roles, as: :entity

  has_many :roles, through: :entity_roles

  has_many :entity_permissions, as: :entity

  has_many :permissions, through: :entity_permissions

  include ZeroRole
  include ZeroPermission

  # enum status: [ :active, :archived ]
  # enum status: { active: 0, archived: 1 }

  has_secure_password

  def conn(role: nil, permission: nil)
    role.present? ? entity_roles.create!(role: role) : entity_permissions.create!(permission: permission)
  end

  # def unconn

  def jwt_payload
    {
        id: id,
        # 使当用户重置密码，所有 token 失效
        hash: Digest::MD5.hexdigest(password_digest).first(6)
    }
  end

  def jwt_claim
    {
        exp_in: 14.days
    }
  end

  # (1) 判断逻辑：when_result && block_result
  #   某项为 nil 时视为 true
  # (2) block 会延迟到调用 is? 时执行；其他的判断会在 model 初始化时执行 setting，立即产生结果
  # (3) 需要注意的是，判断是否角色的操作是或等，即当重复设置角色时，只要有一次判断为真，
  #   最终结果即为真。例如：
  #   is :admin, never
  #   is :admin, always
  #   is :admin, never
  #   is? :admin? => true
  def roles_setting
    super()

    # is [:admin, :master], when: true
    # group :admin, :master, name: :ad
    # group_roles :da, members: %i[admin master]
    # Group just as Roles array
    group_roles :ad do
      is :admin,  when: admin?
      is :master, always # => is `master`
    end

    # level is vip; user is level when self.when.true? && parent of level is? true
    # vip can => level can -- why?
    #   `can :do, role: :vip`, and `level is vip`(is? :vip => true), so `can? :do` is true
    #   when from db, base_role will be load and get it's permissions
    family :vip, when: false do # when: vip?
      is :level1, always # is not level1 cause is not vip
      is :level2, never
    end

    # parent_set :level3, :level4, to: :vip
    # is :vip, when: true, children: %i[]
    # is :level1, parent: :vip

    is :other, when: !admin? # => is `other`
    is :people do
      !admin? # => is `people`
    end
    # is :people { admin? }
  end

  def admin?
    false
  end

  # (1) 判断逻辑：when_result && is? role && block_result
  #   某项为 nil 时视为 true
  # (2) block 会延迟到调用 can? 时执行；其他的判断会在 model 初始化时执行 setting，立即产生结果
  def permissions_setting
    super()

    role :admin, can: :login
    # role :admin, :people, can: [:signup, :logout]
    role %i[admin people], can: %i[signup logout] # => can `signup` and `logout`
    can :login, role: :admin
    # can :login, when: proc { is? :admin }

    role :admin, can: :update, model: User, when: id == 1
    can :update, User, role: :admin, when: id == 1

    # role :other, can: :talk_to, model: User, if_case: :id_eql
    role :other, can: :talk_to, model: User do |dist|
      relation_with? dist
    end
    # 相同的 action_source，其 block 只要有一个为 true，且 when 也为 true，就表示 it can
    can :talk_to, User, if_case do |dist| # TODO: only_case
      is?(:people) && relation_with?(dist)
    end # => cannot judge

    role_group :ad, can: :read # => can `read`
    role :vip, can: :say_hi
    role :level1, can: :say_hello

    # 无权限调用方法时会抛异常
    role :admin, can_call: :hello
    # can_call :hello, role: :other
  end

  def hello
    puts 'hello'
  end

  def fight
    'pong'
  end

  def fighting
    puts 'fighting'
  end

  def relation_with?(user)
    user.id == id
  end
end
