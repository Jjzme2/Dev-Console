// Tables
$('#reminderTable').DataTable({
    search: true,
    ordering: true,
    paging: true,
    order: [ [ 4, 'desc' ], [ 3, 'asc' ],  [ 0, 'asc' ], [ 2, 'asc' ], [ 1, 'asc' ] ]
});

$('#overdueReminderTable').DataTable({
    ordering: true,
    paging: false,
    dom: 'lrt',
    order: [ [ 4, 'desc' ], [ 3, 'asc' ], [ 0, 'asc' ], [ 2, 'asc' ], [ 1, 'asc' ] ]
});

$('#userTable').DataTable({
    search: true,
    ordering: true,
    paging: true,
});

$('#messageTable').DataTable({
    search: true,
    ordering: true,
    paging: true,
});

$('#quotesTable').DataTable({
    search: true,
    ordering: true,
    paging: true,
});

$('#bookmarkTable').DataTable({
    search: true,
    ordering: true,
    paging: true,
});

$('#bookmark-modal-Table').DataTable({
    search: true,
    ordering: true,
    paging: true,
});


$('#notesTable').DataTable({
    search: true,
    ordering: true,
    paging: true,
});