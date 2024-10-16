// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.19;

contract Booking {
    // Errors
    error Booking_TransactionFailed();
    error Booking_TaskNotCompleted();
    error Booking_OnlyClientIsAllowed();
    error Booking_OnlyWorkerIsAllowed();
    error Booking_PaymentRequired();
    error Booking_TaskNotAvailableToAccept();
    error Booking_TaskNotInProgress();
    error Booking_TaskIsAlreadyInProgress();
    error Booking_TakingNotCompleted();
    error Booking_TakingNotCompletedByWorker();

    struct Task {
        uint256 id;
        uint256 amount;
        TaskStatus status;
        address payable worker;
        address payable client;
    }

    enum TaskStatus {
        Booked,
        InProgress,
        Completed,
        Verified,
        Paid,
        Cancelled
    }

    mapping(uint256 => Task) private s_tasks;
    uint256 nextTaskId;

    // events
    event BookingCreated(
        address indexed client,
        address indexed worker,
        uint256 amount
    );
    event BookingPaymentReleased(
        address indexed client,
        address indexed worker,
        uint256 amount,
        bool success
    );
    event BookingTaskStatusChange(uint256 id, TaskStatus status);
    // modifiers

    modifier onlyClient(uint256 _task) {
        if (s_tasks[_task].client == msg.sender) {
            revert Booking_OnlyClientIsAllowed();
        }
        _;
    }

    modifier onlyWorker(uint256 _task) {
        if (s_tasks[_task].client == msg.sender) {
            revert Booking_OnlyClientIsAllowed();
        }
        _;
    }

    constructor() {}

    // When a client books a service, they call this function to deposit the payment into the contract.
    function initialEscrow(address payable _worker) public payable {
        if (msg.value < 1) {
            revert Booking_PaymentRequired();
        }
        s_tasks[nextTaskId] = Task({
            id: nextTaskId,
            client: payable(msg.sender),
            worker: _worker,
            amount: msg.value,
            status: TaskStatus.Booked
        });

        nextTaskId++;
    }

    // Upon task completion and client approval, this function releases the funds to the janitor.
    function releasePayment(uint256 _taskId) internal onlyClient(_taskId) {
        Task storage task = s_tasks[_taskId];

        if (task.status != TaskStatus.Verified) {
            revert Booking_TaskNotCompleted();
        }

        s_tasks[_taskId].status = TaskStatus.Paid;
        uint256 amount = task.amount;

        (bool success, ) = task.worker.call{value: amount}("");
        if (!success) {
            revert Booking_TransactionFailed();
        }
    }

    function refundPayment() public {}

    function acceptTask(uint256 _taskId) external onlyWorker(_taskId) {
        Task storage task = s_tasks[_taskId];
        if (task.status != TaskStatus.Booked) {
            revert Booking_TaskNotAvailableToAccept();
        }

        s_tasks[_taskId].status = TaskStatus.InProgress;
        emit BookingTaskStatusChange(_taskId, task.status);
    }

    function completeTask(uint256 _taskId) external onlyWorker(_taskId) {
        Task storage task = s_tasks[_taskId];
        if (task.status != TaskStatus.InProgress) {
            revert Booking_TaskNotInProgress();
        }

        task.status = TaskStatus.Completed;

        emit BookingTaskStatusChange(_taskId, task.status);
    }

    function verifyTask(uint256 _taskId) external onlyClient(_taskId) {
        Task storage task = s_tasks[_taskId];
        if (task.status != TaskStatus.Completed) {
            revert Booking_TaskNotCompleted();
        }
        task.status = TaskStatus.Verified;
        releasePayment(_taskId);
        emit BookingTaskStatusChange(_taskId, task.status);
    }

    function cancelTask(uint256 _taskId) external {
        Task storage task = s_tasks[_taskId];
        if (task.status != TaskStatus.Booked) {
            revert Booking_TaskIsAlreadyInProgress();
        }
        if (task.client != msg.sender || task.worker != msg.sender) {
            revert Booking_TaskIsAlreadyInProgress();
        }

        (bool success, ) = task.client.call{value: task.amount}("");

        if (!success) {
            revert Booking_TransactionFailed();
        }

        task.status = TaskStatus.Cancelled;
        emit BookingTaskStatusChange(_taskId, task.status);
    }

    function getTask(
        uint256 _taskId
    ) external view onlyWorker(_taskId) returns (Task memory) {
        return s_tasks[_taskId];
    }
}
