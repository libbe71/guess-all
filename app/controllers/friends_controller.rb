class FriendsController < ApplicationController
  before_action :authorize_user!, except: [:create, :accept, :delete, :search_friends, :search_users, :search_received ]

  def show
    @pending = Friend.where(user_id: params[:id], status: 'pending')
    @accepted = Friend.where(user_id: params[:id], status: 'accepted')
  end

  def create
    friend_id = friends_send_params[:friend_id]
    friend_request = Friend.new(user1_id: @current_user&.id, user2_id: friend_id, status: 'pending')
    save = friend_request.save;
    if(save)
      flash[:notice] = "request sent"
    else
      flash[:error] = "request error"
    end
  end

  def accept
    friend_id = friends_send_params[:friend_id]
    friend = Friend.find_by(user1_id: @current_user&.id, user2_id: friend_id) ||
            Friend.find_by(user2_id: @current_user&.id, user1_id: friend_id)

    if friend&.update(status: "accepted")
      flash[:notice] = "Friendship updated"
    else
      flash[:error] = "Error updating friendship"
    end
  end

  def delete
    friend_id = friends_send_params[:friend_id]
    friend = Friend.find_by(user1_id: @current_user&.id, user2_id: friend_id) ||
            Friend.find_by(user2_id: @current_user&.id, user1_id: friend_id)

    if friend&.destroy
      flash[:notice] = "Friendship deleted"
    else
      flash[:error] = "Error deleting friendship"
    end
  end


  def index_users
    if friends_search_params[:search_query].present?
      search_query = friends_search_params[:search_query]
      @users = search_users(search_query).where(role: "user")
    else
      @users = User.all.where(role: "user")
    end

    @users = @users&.paginate(page: 1, per_page: 10)
  end

  def index
    search_query = friends_search_params[:search_query]
    @friends = fetch_accepted_requests(search_query)
  end

  def index_sent
    search_query = friends_search_params[:search_query]
    @sent = fetch_sent_requests(search_query)
  end

  def index_received
    search_query = friends_search_params[:search_query]
    @received = fetch_received_requests(search_query)
  end

  def search_sent(search_query = nil)
    search_query = search_query || friends_search_params[:search_query]
    sent = fetch_sent_requests(search_query)

    sent = sent&.paginate(page: 1, per_page: 10)
    render json: sent
  end

  def search_received(search_query = nil)
    search_query = friends_search_params[:search_query]
    received = fetch_received_requests(search_query)

    received = received&.paginate(page: 1, per_page: 10)
    render json: received
  end

  def search_friends(search_query = nil)
    search_query = friends_search_params[:search_query]
    friends = fetch_accepted_requests(search_query)

    friends = friends&.paginate(page: 1, per_page: 10)
    render json: friends
  end

  def search_users(search_query = nil)
    search_query = friends_search_params[:search_query]
    users = fetch_users(search_query)

    users = users&.paginate(page: 1, per_page: 10)
    render json: users
  end

  private

  def fetch_sent_requests(search_query)
    search_query = "%#{search_query}%" if search_query.present?
    current_user = @current_user
    current_id = current_user.id

    users = Friend
              .select("users.id, friends.status, users.username, users.email_address")
              .joins('JOIN users ON users.id = friends.user2_id')
              .where(user1_id: current_id, status: 'pending')
              .where.not(users: { username: current_user.username, email_address: current_user.email_address })

    if search_query
      users = users.where("users.username LIKE :search OR users.email_address LIKE :search", search: search_query)
    end

    users.distinct
  end

  def fetch_received_requests(search_query)
    search_query = "%#{search_query}%" if search_query.present?
    current_user = @current_user
    current_id = current_user.id

    users = Friend
    .select("users.id, friends.status, users.username, users.email_address")
    .joins('JOIN users ON users.id = friends.user1_id')
    .where(user2_id: current_id, status: 'pending')
    .where.not(users: { username: current_user.username, email_address: current_user.email_address })

    if search_query
      users = users.where("users.username LIKE :search OR users.email_address LIKE :search", search: search_query)
    end

    users.distinct
  end 

  def fetch_accepted_requests(search_query = nil)
    search_query = "%#{search_query}%" if search_query.present?
    current_user = @current_user
    current_id = current_user.id

    # Creating Arel tables
    friends_table = Friend.arel_table
    users_table = User.arel_table

    # Sent friend requests query
    sent_requests = friends_table
                      .project(users_table[:id], friends_table[:status], users_table[:username], users_table[:email_address])
                      .join(users_table).on(users_table[:id].eq(friends_table[:user2_id]))
                      .where(friends_table[:user1_id].eq(current_id).and(friends_table[:status].eq('accepted')))

    # Received friend requests query
    received_requests = friends_table
                          .project(users_table[:id], friends_table[:status], users_table[:username], users_table[:email_address])
                          .join(users_table).on(users_table[:id].eq(friends_table[:user1_id]))
                          .where(friends_table[:user2_id].eq(current_id).and(friends_table[:status].eq('accepted')))

    # Combining the queries with Arel union
    combined_query = sent_requests.union(received_requests)

    # Executing the combined query
    users = User.find_by_sql(combined_query.to_sql)

    # Converting the result to ActiveRecord relation to apply further filters if needed
    users_relation = User.where(id: users.map(&:id))

    # Applying the search query if present
    if search_query
      users_relation = users_relation.where("username LIKE :search OR email_address LIKE :search", search: search_query)
    end

    users_relation.distinct
  end



def fetch_users(search_query)
  search_query = "%#{search_query}%"
  current_id = @current_user.id
  current_username = @current_user.username
  current_email_address = @current_user.email_address

  # Get friends' IDs where the current user is either user1 or user2
  friends1_ids = Friend.where(user2_id: current_id).pluck(:user1_id)
  friends2_ids = Friend.where(user1_id: current_id).pluck(:user2_id)
  friends_ids = friends1_ids + friends2_ids

  # Fetch users excluding the current user and their friends
  users = User.where.not(id: friends_ids + [current_id])
              .where('username LIKE :search OR email_address LIKE :search', search: search_query)
              .distinct

  return users
end


  def friends_send_params
   params.require(:friend).permit(:friend_id)
  end
  def friends_search_params
    params.permit(:id, :locale, :search_query)
  end
end
